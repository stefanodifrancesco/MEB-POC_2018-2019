# MEB-POC_2018-2019

# Table of contents
1. [Introduction](#introduction)
2. [Instructions](#instructions)
    1. [MySQL Cluster](#mysql)
    2. [Kafka](#kafka)
    2. [BroadcastListener](#broadcastListener1)
3. [Running](#running)
    1. [Kafka Stream](#stream)
    2. [Broadcast listener](#broadcastListener2)
    3. [Tools simulator](#simulator)
    4. [Report tool](#report)

## Introduction <a name="introduction"></a>
The ToolsSimulator will simulate 800 tools broadcasting 150000 XML messages in 30 minutes. Half of them contains the start time of an holding operation, the other half contains the end time. Every message brings the tool OID, the recipe OID and the type of hold.
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

###### my.cnf
```
[mysqld]
ndbcluster
datadir=C:\\YOUR_PATH\\mysqlc\\my_cluster\\mysqld_data
basedir=C:\\YOUR_PATH\\mysqlc
port=5000
```
###### config.ini
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

> NOTE: The file *sink-connect-jdbc.properties* contains the name of the output topic that must be equal to the name of the corresponding table on analytics database, and the parameters for the connection to MySQL Cluster


### BroadcastListener<a name="BroadcastListener1"></a>

This software accept a single command line argument containing a string-encoded JSON with all parameters.
This software can run in 2 different mode: Master and Slave (replica).
The master instances of this program are one doing all the required operation.
The slave instances are there for resilence and fault-recovery.
Each slave is assigned to exactly one master. 
If his master will stop responding for a customizable amount of time, the old master is assumed to be dead and one of the slaves of that master will be the new master.
An usage example for command line arguments is at end of this file.
If you run the application without any parameters it will run with default parameters.
If you run the application with any invalid parameter it will show you the suggested default parameters and will copy them in the clipboard to aid the generation of custom parameters by modifying that default setup.
Therefore i suggest doing the first run with explicitely wrong parameters to get the suggested setup as a starting point and customize that.

The acceptable parameters are:

***

`        public int broadcastPortTool, broadcastPort_Slaves;`

Those parameters indicate the port on which Tool message and intra-communication messages are sent. 
if there is more than 1 partition of BroadcastReceiver running, they must be different, and every partition must have a  different broadcastPort_Slaves port.
It is suggested to separate them anyways.


`         public bool enableGUI;`

   Enable gui for debugging purpouse, it is the main bottleneck for performance and it should be disabled in production.


`         public List<Slave> replicatorsList;`

 List of replicas with their own arguments, check the example at end for syntax of setting Slave argument.


`         public int myPartitionNumber, partitionNumbers_Total;`

 If one BroadcastListener is not enough, the load can be partitioned across multiple "master" running toghether and splitting the load. Each muster must be assigned to a different partition number, otherwise their work will overlap generating duplication or messages unaccepted by any master.
Every master have his personal replica-Slave list, all with same partition number of master.
Basically every partition must hold exactly 1 master and N slaves.
myPartitionNumber must be a integer number from 0 to partitionNumbers_Total-1; by default is is the binary value of Mac address (should be unique if not hacked), stored in a integer. 


`        public int toolReceiverThreads, slaveReceiverThreads;`

 Specify how much thread should be executed for receiving messages in parallel.
 The default suggested value is computed basing of the logical cores of the hosting machine. 


`        public string broadcastAddress;`

 The broadcast address of your local network


`        public string logFile, errFile, criticalErrFile, toolMsgFile, slaveMsgFile;`

Those field are for debug, each one of them can be independently null.
logFile holds general information about thread, buffer, queue, and workload status.
errFile holds information about unexpected but recoverable errors, they have little impact on the service, even in the worst case they will just generate the loss of a message.
criticalErrFile holds information about unexpected and unrecoverable errors, such as invalid arguments. A single critical error will cause the whole application to stop.
toolMsgFile holds information about messages from tools, logged either on the received event or on the kafka-publising-success event, customizable in a following boolean.
slaveMsgFile holds information about intra-communication messages across master and slaves of the same partition.
In production, for performance reason, it is suggested to keep only the error logs.
Ideally they will be never used anyway, so they should not impact the service and there is no reason to disable them. 


`         public int slaveNotifyMode_Batch;`

if greater than 0 allow notifying multiple message publishing confirmation to the slaves with a single intra-message.
the value 0 means the feature is disabledd and there will be a publishing confirm for each message (doubling network load)
the value 1 makes little sense but is not forbidden, it is functionally equal to feature disabled, with worst performance.
values greater than 1 are the maximum message publishing confirmed with a single intra-message.
if the queue rech 0 messages, a batch-confirmation message will be sent regardless to avoid latency in the notification of slaves, just before the publisher will block itself.


`        public bool dinamicallyStarted;`

true if this running instance has been executed after his slave-master peers.
it will announce itself to all peers to dinamically add itself into the partition as a slave.


`        public bool logToolMsgOnReceive;`

 specify when to log tool messages: when received or when published to kafka.
 to avoid logging at all disable both toolMsgFile and enableGUI.


`        public bool exclusiveBind;`

 Specify if the receiving endpoint for tool and intra-communication broadcast should be exclusively accessed.
 That also mean that only one thread for receiver kind can run.
 It is suggested to use it only if other applications on this machine are reading that broadcast port, but the better choice would be to simply change the port number argument in both tools and this application if possible.


`        public string KafkaNodes;`

 List of kafka hosting nodes. Comma-separated with format "http://Address:Port" or "URI:Port"


`        public string KafkaTopic;`

 The topic in which the tool message should be published.


`        public bool benchmark;`

Enables test mode and display performance statistics when the program is closed through GUI, requires enableGUI=true.


`        public int maxExpectedMessageDelay;`

if master's slaveNotifyMode_Batch = false, this is meaningless, this is meaningless in a master's fault-less execution too.
The full meaning of this parameter is explained in "broadcastListener slave dequeue" sequence diagram.
A big value will increase duplicates in case of master's fault or a small value will increase the risk of losing a message.
The value is expressed in milliseconds.


***

Default arguments suggested for my machine (partly automatically generated):

`{"broadcastPort_Tool":20001,"broadcastPort_Slaves":20002,"enableGUI":true,"replicatorsList":[{"ip_string":"192.168.1.100","id":8796095578122,"isSelf":true},{"ip_string":"192.168.1.101","id":8796095578123,"isSelf":false},{"ip_string":"192.168.1.102","id":8796095578124,"isSelf":false}],"myPartitionNumber":0,"partitionNumbers_Total":1,"toolReceiverThreads":2,"slaveReceiverThreads":2,"broadcastAddress":"192.168.1.255","logFile":"C:\\Users\\diama\\Desktop\\Listener_EventLog.txt","errFile":"C:\\Users\\diama\\Desktop\\Listener_Errors.txt","criticalErrFile":"C:\\Users\\diama\\Desktop\\Listener_CriticalErrors.txt","toolMsgFile":"C:\\Users\\diama\\Desktop\\Listener_ToolLog.txt","slaveMsgFile":"C:\\Users\\diama\\Desktop\\Listener_SlaveLog.txt","slaveNotifyMode_Batch":100,"dinamicallyStarted":false,"logToolMsgOnReceive":false,"exclusiveBind":false,"KafkaNodes":"http://localhost:9093, http://localhost:9094, http://localhost:9094","KafkaTopic":"toolsEvents","benchmark":true}`

## Running <a name="running"></a>

### Kafka Stream <a name="stream"></a>

#### Start Kafka Stream processors
###### There are three Kafka Stream instances in the Release folder, you can run all of them to improve scalability
```
shell> cd Release\KafkaStream_Instance1
shell> java -cp StreamProcessor-0.0.1-SNAPSHOT-jar-with-dependencies.jar it.univaq.disim.SA.MEB_POC.StreamProcessor.Main
```
###### Each instance folder contains also a configuration file:
###### config.properties
```
inputtopic: toolsEvents
outputtopic: aggregateddata
servers: localhost:9093,localhost:9094,localhost:9095
mysqlcluster.url: jdbc:mysql://localhost:5000/raw_data?serverTimezone=UTC
mysqlcluster.user: root
mysqlcluster.password: root
```
> NOTE: Pay attention to the output topic name that must be equal to the name of the corresponding table on analytics database

### Broadcast listener <a name="broadcastListener2"></a>
#### Prerequisites:
All required dynamical linking libraries are already in place, .Net Framework 4.7 or higher is required on hosting machine.

#### Launch:
There are 2 pre-made batch file with for one-click running 2 master instances with different parameters that are splitting the load in 2 partition in the folder *Release\BroadcastListener*. You can either start those two instances of the listener using the scripts  *BroadcastListener launcher - 1 of 2.bat* and *BroadcastListener launcher - 2 of 2.bat* or run it multiple times with customized parameters.

### Tools simulator <a name="simulator"></a>
Open a shell in the folder *Release\ToolsSimulator* and give the following command:
```
shell> java -cp .\ToolsSimulator-0.0.1-SNAPSHOT-jar-with-dependencies.jar it.univaq.disim.SA.MEB_POC.ToolsSimulator.Main
```

### Report tool <a name="report"></a>
The *Report tool* folder contains a .php file to be runned on a server.
