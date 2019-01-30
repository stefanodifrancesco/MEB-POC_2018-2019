# MEB-POC_2018-2019

# Instructions

#### Kafka (localhost)

#### Start ZooKeeper Service

```
.\bin\windows\zookeeper-server-start.bat .\config\zookeeper.properties
```
#### Start three Kafka nodes 

```
.\bin\windows\kafka-server-start.bat .\config\server.1.properties
```

```
.\bin\windows\kafka-server-start.bat .\config\server.2.properties
```

```
.\bin\windows\kafka-server-start.bat .\config\server.3.properties
```
#### Create three topics

```
.\bin\windows\kafka-topics.bat --create --topic toolsEvents --zookeeper localhost:2181 --partitions 3 --replication-factor 2
```

```
.\bin\windows\kafka-topics.bat --create --topic globalTableHoldON --zookeeper localhost:2181 --partitions 3 --replication-factor 2
```

```
.\bin\windows\kafka-topics.bat --create --topic aggregateddata --zookeeper localhost:2181 --partitions 3 --replication-factor 2
```
#### Start JDBC Sink Connector

```
.\bin\windows\connect-standalone.bat .\config\connect-standalone.properties .\config\sink-connect-jdbc.properties
```
#### Start three Kafka Stream processor
```
java -cp .\instance1\StreamProcessor-0.0.1-SNAPSHOT-jar-with-dependencies.jar it.univaq.disim.SA.MEB_POC.StreamProcessor.Main
```
```
java -cp .\instance2\StreamProcessor-0.0.1-SNAPSHOT-jar-with-dependencies.jar it.univaq.disim.SA.MEB_POC.StreamProcessor.Main
```
```
java -cp .\instance3\StreamProcessor-0.0.1-SNAPSHOT-jar-with-dependencies.jar it.univaq.disim.SA.MEB_POC.StreamProcessor.Main
```
