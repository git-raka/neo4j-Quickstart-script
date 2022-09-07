#!/bin/bash
echo "https://github.com/rakaa-dev "
yum install java-11-openjdk-devel -y
wget https://neo4j.com/artifact.php?name=neo4j-enterprise-4.4.10-unix.tar.gz

cp 'artifact.php?name=neo4j-enterprise-4.4.10-unix.tar.gz'  neo4j-enterprise-4.4.10-unix.tar.gz && rm 'artifact.php?name=neo4j-enterprise-4.4.10-unix.tar.gz'
tar -xvf neo4j-enterprise-4.4.10-unix.tar.gz

var=$(pwd)
echo "The current working directory $var"

#define filename
cd $var/neo4j-enterprise-4.4.10/conf
filename='neo4j.conf'

# Define ip
ip=$(ip route get 8.8.8.8 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}' | awk '{print $1}')
echo "the ip for Neo4j= $ip"

# Configuration
echo "dbms.security.procedures.unrestricted=apoc.*,gds.*,bloom.*
dbms.security.procedures.allowlist=apoc.*,gds.*,bloom.*
apoc.import.file.enabled=true
apoc.import.file.use_neo4j_config=true
dbms.default_listen_address=0.0.0.0
dbms.default_advertised_address=$ip" >> $filename

# add plugin
cd $var/neo4j-enterprise-4.4.10/plugins
wget https://github.com/neo4j/graph-data-science/releases/download/2.1.8/neo4j-graph-data-science-2.1.8.jar
wget https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/4.4.0.8/apoc-4.4.0.8-all.jar

# start neo4j

cd $var/neo4j-enterprise-4.4.10/bin/
./neo4j start
rm -rf neo4j-enterprise-4.4.10-unix.tar.gz

echo "NEO4J SUCCESFULY INSTALLED"
