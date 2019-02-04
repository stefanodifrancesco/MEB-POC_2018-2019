# MEB-POC_2018-2019

# Table of contents
1. [Introduction](#introduction)
2. [Instructions](#instructions)
    1. [MySQL Cluster](#mysql)
    2. [Kafka](#kafka)
3. [Running report tool](#running)

## Introduction <a name="introduction"></a>
The ToolsSimulator will simulate 400 tools broadcasting 80000 XML messages in 30 minutes. Half of them contains the start time of an holding operation, the other half contains the end time. Every message brings the tool OID, the recipe OID and the type of hold.
The broadcast listener will intercept all this messages and publish them on the topic 'toolsEvents' of Kafka.   
The StreamProcessor will aggregate them retrieving common names of tools and recipes from 'raw_data' database stored in MySQL Cluster.  
It will also join start and end times to create a single aggregated messaged republished on the 'aggregateddata' topic.  
Then, a plugin of Kafka will take care of inserting this final messages to the 'analytics_database'.  
The report tool can be used to analyze the history of messages.

## Instructions <a name="instructions"></a>

### MySQL Cluster (localhost) <a name="mysql"></a>

Please download the ZIP archive of MySql Cluster from one of the following links:

[MySQL Cluster, ZIP Archive 32-bit](https://dev.mysql.com/downloads/file/?id=484007)

[MySQL Cluster, ZIP Archive 64-bit](https://dev.mysql.com/downloads/file/?id=484008)

Extract the archive and rename the folder as *mysqlc*

Open a command prompt in the extracted folder and run:

```
shell> .\bin\mysqld --initialize-insecure
```
We will set a password at the end. Now create the following directory tree:
```
shell> mkdir my_cluster my_cluster\ndb_data my_cluster\mysqld_data my_cluster\conf my_cluster\mysqld_data\mysql my_cluster\mysqld_data\ndbinfo my_cluster\mysqld_data\performance_schema
```
Create two file in the *conf* folder:
> NOTE: Change **YOUR_PATH** to point the directories just created

#### my.cnf
```
[mysqld]
ndbcluster
datadir=C:\\YOUR_PATH\\mysqlc\\my_cluster\\mysqld_data
basedir=C:\\YOUR_PATH\\mysqlc
port=5000
```
#### config.ini
```
[ndb_mgmd]
# Management process options:
HostName=localhost                                    # Hostname or IP address of management node
DataDir=C:\\YOUR_PATH\\mysqlc\\my_cluster\\ndb_data   # Directory for management node log files
NodeId=1

[ndbd default]
NoOfReplicas=2
DataDir=C:\\YOUR_PATH\\mysqlc\\my_cluster\\ndb_data

[ndbd]
# Options for data node "A":	
HostName=localhost              # Hostname or IP address
NodeId=3

[ndbd]
# Options for data node "B":
HostName=localhost              # Hostname or IP address
NodeId=4

[mysqld]
# SQL node options:
#HostName=localhost             # Hostname or IP address
NodeId=50
```
Copy necessary schemas initialized before:
```
shell> copy data\mysql my_cluster\mysqld_data\mysql
shell> copy data\ndbinfo my_cluster\mysqld_data\ndbinfo
shell> copy data\performance_schema my_cluster\mysqld_data\performance_schema
```
Start the ndb manager service with the following command where the string YOUR_PATH is replaced with the path to your *mysqlc* folder:
```
shell> .\bin\ndb_mgmd -f .\my_cluster\conf\config.ini --initial --configdir=C:\YOUR_PATH\mysqlc\my_cluster\conf
```

Run two nodes for the cluster as stated in the **config.ini**, running the following command on two different command prompts opened in the *mysqlc* folder:
```
shell> .\bin\ndbd -c localhost:1186
```
With another command prompt you can see the status of the nodes with the following tool:
```
shell> .\bin\ndb_mgm -e show
```
> NOTE: If the *mysqld* node with id=50 is connected, please stop any other process named *mysqld* running on the system. 

Finally run the mysqld service with:
```
shell> .\bin\mysqld --defaults-file=my_cluster\conf\my.cnf --console
```
Open the *mysql* shell running:
```
shell> .\bin\mysql -u root --skip-password --port=5000
```
Now set a password for the **root**:
```
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';
```
Now import 'raw_data' and 'analytics_database' from the folder *MySQL Cluster Dump* of your local repository:
```
shell> .\bin\mysql -u root -p --port=5000 < "C:\YOUR_PATH_TO_REPOSITORY\MySQL Cluster Dump\dump.sql"
```

### Kafka (localhost) <a name="kafka"></a>

> NOTE: Following commands run on Windows. On unix systems you can use sh scripts in bin folder 

Open a Powershell on the root of Kafka directory:

#### Start ZooKeeper Service

```
shell> .\bin\windows\zookeeper-server-start.bat .\config\zookeeper.properties
```
#### Start three Kafka nodes 

```
shell> .\bin\windows\kafka-server-start.bat .\config\server.1.properties
shell> .\bin\windows\kafka-server-start.bat .\config\server.2.properties
shell> .\bin\windows\kafka-server-start.bat .\config\server.3.properties
```
#### Create the input and output topics

```
shell> .\bin\windows\kafka-topics.bat --create --topic toolsEvents --zookeeper localhost:2181 --partitions 3 --replication-factor 2
shell> .\bin\windows\kafka-topics.bat --create --topic aggregateddata --zookeeper localhost:2181 --partitions 3 --replication-factor 2
```
#### Start one or more instances of the JDBC Sink Connector plugin

```
shell> .\bin\windows\connect-standalone.bat .\config\connect-standalone1.properties .\config\sink-connect-jdbc.properties
shell> .\bin\windows\connect-standalone.bat .\config\connect-standalone2.properties .\config\sink-connect-jdbc.properties
shell> .\bin\windows\connect-standalone.bat .\config\connect-standalone3.properties .\config\sink-connect-jdbc.properties
```
#### Start Kafka Stream processors
###### There are three Kafka Stream instances in the Release folder, you can run all of them to improve scalability
```
shell> cd Release\KafkaStream_Instance1
shell> java -cp StreamProcessor-0.0.1-SNAPSHOT-jar-with-dependencies.jar it.univaq.disim.SA.MEB_POC.StreamProcessor.Main
```
###### Each instance folder contains also a configuration file:
#### config.properties
```
inputtopic: toolsEvents
outputtopic: aggregateddata
servers: localhost:9093,localhost:9094,localhost:9095
mysqlcluster.url: jdbc:mysql://localhost:5000/raw_data?serverTimezone=UTC
mysqlcluster.user: root
mysqlcluster.password: root
```
> NOTE: Pay attention to the output topic name that must be equal to the name of the corresponding table on analytics database
## Running report tool<a name="running"></a>
The *Report tool* folder contains a .php file to be runned on a server.
