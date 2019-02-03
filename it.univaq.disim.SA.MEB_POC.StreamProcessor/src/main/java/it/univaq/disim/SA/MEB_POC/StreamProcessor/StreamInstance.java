package it.univaq.disim.SA.MEB_POC.StreamProcessor;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.StringReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.xml.bind.JAXB;

import org.apache.kafka.common.serialization.Serdes;
import org.apache.kafka.streams.KafkaStreams;
import org.apache.kafka.streams.KeyValue;
import org.apache.kafka.streams.StreamsBuilder;
import org.apache.kafka.streams.StreamsConfig;
import org.apache.kafka.streams.kstream.GlobalKTable;
import org.apache.kafka.streams.kstream.KStream;
import org.apache.kafka.streams.kstream.KeyValueMapper;
import org.apache.kafka.streams.kstream.Predicate;
import org.apache.kafka.streams.kstream.ValueJoiner;

import it.univaq.disim.SA.MEB_POC.StreamProcessor.Models.InhibitEvent;

public class StreamInstance {
	
	// If running from Eclipse the following settings will be used
	private final static String INPUTTOPIC = "toolsEvents";
	private final static String OUTPUTTOPIC = "aggregateddata";
	private final static String BOOTSTRAP_SERVERS = "localhost:9092,localhost:9093,localhost:9094";
	private final static String RAW_DATA_DATABASE_URL = "jdbc:mysql://localhost:5000/raw_data";
	private final static String RAW_DATA_DATABASE_USER = "root";
	private final static String RAW_DATA_DATABASE_PASSWORD = "root";

	static Connection rawdataConn = null;
	static PreparedStatement rawdataPrepareStat = null;
	/*static int holdONCounter;
	static int holdOFFCounter;*/
	static int publishedCounter;

	static void runStream() {

		makeJDBCConnection();

		Properties props = new Properties();
		props.put(StreamsConfig.BOOTSTRAP_SERVERS_CONFIG, getServers());
		// Setting the following property is necessary for instances synchronization
		// The application.id should be the same for all instances
		props.put(StreamsConfig.APPLICATION_ID_CONFIG, "MEBKafkaStreamCluster");
		props.put(StreamsConfig.DEFAULT_KEY_SERDE_CLASS_CONFIG, Serdes.String().getClass().getName());
		props.put(StreamsConfig.DEFAULT_VALUE_SERDE_CLASS_CONFIG, Serdes.String().getClass().getName());
		props.put(StreamsConfig.DEFAULT_TIMESTAMP_EXTRACTOR_CLASS_CONFIG, TimeExtractor.class.getName());
		// Setting the following property is only used in testing scenarios for running
		// more instances on localhost
		// If not set the default directory is "/tmp/kafka-streams"
		// props.put(StreamsConfig.STATE_DIR_CONFIG, "/tmp/kafka-streams1-dir");
		// props.put(StreamsConfig.STATE_DIR_CONFIG, "/tmp/kafka-streams2-dir");
		// props.put(StreamsConfig.STATE_DIR_CONFIG, "/tmp/kafka-streams3-dir");

		StreamsBuilder builder = new StreamsBuilder();

		KStream<String, String> inputStream = builder.stream(getInputTopic());

		KStream<String, String> holdONStream = inputStream.filter(new Predicate<String, String>() {
			public boolean test(String key, String value) {
				InhibitEvent event = JAXB.unmarshal(new StringReader(value), InhibitEvent.class);
				if (event.getInserted().getHold_flag().equals("Y")) {
					/*holdONCounter += 1;
					System.out.println("holdON arrived: " + holdONCounter);*/

					return true;
				} else {
					return false;
				}
			}
		});
		holdONStream.to("globalTableHoldON");

		// The HoldOn events are store in a GlobalKTable to be read by every Kafka
		// Stream instance of the 'MEBKafkaStreamCluster'
		GlobalKTable<String, String> globalTableHoldON = builder.globalTable("globalTableHoldON");

		KStream<String, String> holdOFFStream = inputStream.filter(new Predicate<String, String>() {
			public boolean test(String key, String value) {
				InhibitEvent event = JAXB.unmarshal(new StringReader(value), InhibitEvent.class);
				if (event.getInserted().getHold_flag().equals("N")) {
					/*holdOFFCounter += 1;
					System.out.println("holdOFF arrived: " + holdOFFCounter);
*/
					return true;
				} else {
					return false;
				}
			}
		});

		// Joins HoldOFF events with HoldOn events stored in the GlobalKTable
		KStream<String, List<InhibitEvent>> joined = holdOFFStream.join(globalTableHoldON,
				new KeyValueMapper<String, String, String>() {

					public String apply(String key, String value) {
						return key;
					}
				}, new ValueJoiner<String, String, List<InhibitEvent>>() {

					public List<InhibitEvent> apply(String value1, String value2) {

						List<InhibitEvent> YandN = new ArrayList<InhibitEvent>();

						InhibitEvent ONevent = JAXB.unmarshal(new StringReader(value2), InhibitEvent.class);
						InhibitEvent OFFevent = JAXB.unmarshal(new StringReader(value1), InhibitEvent.class);

						YandN.add(ONevent);
						YandN.add(OFFevent);
						System.out.println("Joining...");
						return YandN;
					}
				});

		KeyValueMapper<String, List<InhibitEvent>, Iterable<KeyValue<String, String>>> mapper = new KeyValueMapper<String, List<InhibitEvent>, Iterable<KeyValue<String, String>>>() {
			public Iterable<KeyValue<String, String>> apply(String key, List<InhibitEvent> YandN) {

				List<KeyValue<String, String>> result = new ArrayList<KeyValue<String, String>>();

				List<String> equipNames;
				String recipeName = "";
				String holdType = "";

				InhibitEvent ONevent = YandN.get(0);
				InhibitEvent OFFevent = YandN.get(1);

				String equipOID = ONevent.getInserted().getEquip_OID();
				String recipeOID = ONevent.getInserted().getRecipe_OID();

				if (!equipOID.equals("")) {
					equipNames = getEquipNameByOID(equipOID);
				} else {
					equipNames = getEquipNamesByRecipeOID(recipeOID);
				}

				recipeName = getRecipeNameByOID(recipeOID);
				holdType = ONevent.getInserted().getHold_type();

				// Generation of KeyValue pairs of JSON (Schema + Payload) for JDBC Sink
				// API Connector reading data from 'aggregateddata' topic
				for (String equipName : equipNames) {
					String json = "{\r\n" + " \"schema\": {\r\n" + "	\"type\": \"struct\",\r\n"
							+ "	\"fields\": [\r\n" + "		{\r\n" + "			\"type\": \"string\",\r\n"
							+ "			\"optional\": false,\r\n" + "			\"field\": \"EquipName\"\r\n"
							+ "		}, \r\n" + "		{\r\n" + "			\"type\": \"string\",\r\n"
							+ "			\"optional\": false,\r\n" + "			\"field\": \"RecipeName\"\r\n"
							+ "		},\r\n" + "		{\r\n" + "			\"type\": \"string\",\r\n"
							+ "			\"optional\": false,\r\n" + "			\"field\": \"HoldType\"\r\n"
							+ "		},\r\n" + "		{\r\n" + "			\"type\": \"string\",\r\n"
							+ "			\"optional\": false,\r\n" + "			\"field\": \"HoldStartDateTime\"\r\n"
							+ "		},\r\n" + "		{\r\n" + "			\"type\": \"string\",\r\n"
							+ "			\"optional\": false,\r\n" + "			\"field\": \"HoldEndDateTime\"\r\n"
							+ "		}\r\n" + "	]\r\n" + " },\r\n" + " \"payload\": {\r\n" + "	\"EquipName\": \""
							+ equipName + "\",\r\n" + "	\"RecipeName\": \"" + recipeName + "\",\r\n"
							+ "	\"HoldType\": \"" + holdType + "\",\r\n" + "	\"HoldStartDateTime\": \""
							+ ONevent.getInserted().getEvent_datetime() + "\",\r\n" + "	\"HoldEndDateTime\": \""
							+ OFFevent.getInserted().getEvent_datetime() + "\"\r\n" + " }\r\n" + "}";

					result.add(new KeyValue<String, String>(key, json));
					publishedCounter++;
					System.out.println("New aggregated data published on output topic - Total: " + publishedCounter);
				}

				return result;
			}
		};

		KStream<String, String> outputStream = joined.flatMap(mapper);
		// The topic name should be of the same name of MySql table in Analytics
		// Database
		outputStream.to(getOutputTopic());

		KafkaStreams myStream = new KafkaStreams(builder.build(), props);
		myStream.start();
	}

	private static void makeJDBCConnection() {
		try {

			rawdataConn = DriverManager.getConnection(getDBurl(), getDBuser(), getDBpassword());
			if (rawdataConn != null) {
				System.out.println("Connection to 'raw_data' DB successful!");
			} else {
				System.out.println("Failed to make connection!");
			}
		} catch (SQLException e) {
			System.out.println("MySQL Connection Failed!");
			e.printStackTrace();
			return;
		}
	}

	private static List<String> getEquipNameByOID(String equip_OID) {

		List<String> final_result = new ArrayList<String>();
		try {
			String getEquipName = "SELECT Name FROM tools WHERE OID = ?";

			rawdataPrepareStat = rawdataConn.prepareStatement(getEquipName);
			rawdataPrepareStat.setString(1, equip_OID);
			ResultSet rs = rawdataPrepareStat.executeQuery();

			while (rs.next()) {
				String name = rs.getString("Name");
				final_result.add(name);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return final_result;
	}

	// It is used for hold events of group of equip with the same recipe
	private static List<String> getEquipNamesByRecipeOID(String recipe_OID) {

		List<String> final_results = new ArrayList<String>();
		try {
			String getEquipNamesByRecipe = "SELECT Name FROM tools WHERE SUBSTRING(OID FROM -4 FOR 4) = ?";

			rawdataPrepareStat = rawdataConn.prepareStatement(getEquipNamesByRecipe);
			rawdataPrepareStat.setString(1, recipe_OID.substring(14, 18));
			ResultSet rs = rawdataPrepareStat.executeQuery();

			while (rs.next()) {
				String name = rs.getString("Name");
				final_results.add(name);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return final_results;
	}

	private static String getRecipeNameByOID(String recipe_OID) {

		String final_result = "";
		try {
			String getRecipeName = "SELECT Name FROM recipes WHERE OID = ?";

			rawdataPrepareStat = rawdataConn.prepareStatement(getRecipeName);
			rawdataPrepareStat.setString(1, recipe_OID);
			ResultSet rs = rawdataPrepareStat.executeQuery();

			while (rs.next()) {
				String name = rs.getString("Name");
				final_result += name;
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return final_result;
	}

	private static String getServers() {

		String servers = null;
		Properties mainProperties = new Properties();

		try {
			FileInputStream file;
			String path = "./config.properties";
			file = new FileInputStream(path);

			mainProperties.load(file);
			file.close();
			servers = mainProperties.getProperty("servers");
		} catch (IOException e) {
			servers = BOOTSTRAP_SERVERS;
		}

		return servers;
	}

	private static String getInputTopic() {

		String inputTopic = null;
		Properties mainProperties = new Properties();

		try {
			FileInputStream file;
			String path = "./config.properties";
			file = new FileInputStream(path);

			mainProperties.load(file);
			file.close();
			inputTopic = mainProperties.getProperty("inputtopic");
		} catch (IOException e) {
			inputTopic = INPUTTOPIC;
		}

		return inputTopic;
	}
	
	private static String getOutputTopic() {

		String OutputTopic = null;
		Properties mainProperties = new Properties();

		try {
			FileInputStream file;
			String path = "./config.properties";
			file = new FileInputStream(path);

			mainProperties.load(file);
			file.close();
			OutputTopic = mainProperties.getProperty("outputtopic");
		} catch (IOException e) {
			OutputTopic = OUTPUTTOPIC;
		}

		return OutputTopic;
	}

	private static String getDBurl() {

		String url = null;
		Properties mainProperties = new Properties();

		try {
			FileInputStream file;
			String path = "./config.properties";
			file = new FileInputStream(path);

			mainProperties.load(file);
			file.close();
			url = mainProperties.getProperty("mysqlcluster.url");
		} catch (IOException e) {
			url = RAW_DATA_DATABASE_URL;
		}

		return url;
	}

	private static String getDBuser() {

		String user = null;
		Properties mainProperties = new Properties();

		try {
			FileInputStream file;
			String path = "./config.properties";
			file = new FileInputStream(path);

			mainProperties.load(file);
			file.close();
			user = mainProperties.getProperty("mysqlcluster.user");
		} catch (IOException e) {
			user = RAW_DATA_DATABASE_USER;
		}
		
		return user;
	}

	private static String getDBpassword() {

		String pass = null;
		Properties mainProperties = new Properties();

		try {
			FileInputStream file;
			String path = "./config.properties";
			file = new FileInputStream(path);

			mainProperties.load(file);
			file.close();
			
			pass = mainProperties.getProperty("mysqlcluster.password");
		} catch (IOException e) {
			pass = RAW_DATA_DATABASE_PASSWORD;
		}

		return pass;
	}
}
