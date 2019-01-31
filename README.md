# MEB-POC_2018-2019

## Instructions

#### MySQL Cluster (localhost)

Please download the ZIP archive of MySql Cluster from one of the following links:

[MySQL Cluster, ZIP Archive 32-bit](https://dev.mysql.com/downloads/file/?id=484007)

[MySQL Cluster, ZIP Archive 64-bit](https://dev.mysql.com/downloads/file/?id=484008)

Extract the archive and rename the folder as *mysqlc*

Open a command prompt in the extracted folder and run:

```
> .\bin\mysqld --initialize-insecure
```
We will set a password at the end. Now create the following directory tree:
```
> mkdir my_cluster my_cluster\ndb_data my_cluster\mysqld_data my_cluster\conf my_cluster\mysqld_data\mysql my_cluster\mysqld_data\ndbinfo my_cluster\mysqld_data\performance_schema
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
> copy data\mysql my_cluster\mysqld_data\mysql
> copy data\ndbinfo my_cluster\mysqld_data\ndbinfo
> copy data\performance_schema my_cluster\mysqld_data\performance_schema
```
Start the ndb manager service with the following command where the string YOUR_PATH is replaced with the path to your *mysqlc* folder:
```
> .\bin\ndb_mgmd -f .\my_cluster\conf\config.ini --initial --configdir=C:\YOUR_PATH\mysqlc\my_cluster\conf
```

Run two nodes for the cluster as stated in the **config.ini**, running the following command on two different command prompts opened in the *mysqlc* folder:
```
> .\bin\ndbd -c localhost:1186
```
With another command prompt you can see the status of the nodes with the following tool:
```
.\bin\ndb_mgm -e show
```
> NOTE: If the *mysqld* node with id=50 is connected, please stop any other process named *mysqld* running on the system. 

Finally run the mysqld service with:
```
> .\bin\mysqld --defaults-file=my_cluster\conf\my.cnf --console
```
Open the *mysql* shell running:
```
.\bin\mysql -u root --skip-password --port=5000
```
Now set a password for the **root**:
```
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'new_password';
```

## Kafka (localhost)

> NOTE: Following commands run on Windows. On unix systems you can use sh scripts in bin folder 

Open a Powershell on the root of Kafka directory:

#### Start ZooKeeper Service

```
> .\bin\windows\zookeeper-server-start.bat .\config\zookeeper.properties
```
#### Start three Kafka nodes 

```
> .\bin\windows\kafka-server-start.bat .\config\server.1.properties
> .\bin\windows\kafka-server-start.bat .\config\server.2.properties
> .\bin\windows\kafka-server-start.bat .\config\server.3.properties
```
#### Create three topics

```
> .\bin\windows\kafka-topics.bat --create --topic toolsEvents --zookeeper localhost:2181 --partitions 3 --replication-factor 2
> .\bin\windows\kafka-topics.bat --create --topic globalTableHoldON --zookeeper localhost:2181 --partitions 3 --replication-factor 2
> .\bin\windows\kafka-topics.bat --create --topic aggregateddata --zookeeper localhost:2181 --partitions 3 --replication-factor 2
```
#### Start JDBC Sink Connector

```
> .\bin\windows\connect-standalone.bat .\config\connect-standalone.properties .\config\sink-connect-jdbc.properties
```
#### Start three Kafka Stream processor
```
> java -cp .\instance1\StreamProcessor-0.0.1-SNAPSHOT-jar-with-dependencies.jar it.univaq.disim.SA.MEB_POC.StreamProcessor.Main
> java -cp .\instance2\StreamProcessor-0.0.1-SNAPSHOT-jar-with-dependencies.jar it.univaq.disim.SA.MEB_POC.StreamProcessor.Main
> java -cp .\instance3\StreamProcessor-0.0.1-SNAPSHOT-jar-with-dependencies.jar it.univaq.disim.SA.MEB_POC.StreamProcessor.Main
```
