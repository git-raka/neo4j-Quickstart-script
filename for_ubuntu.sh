#!/bin/bash
echo "https://github.com/git-raka"
sudo apt install openjdk-11-jre-headless -y
wget https://neo4j.com/artifact.php?name=neo4j-enterprise-4.4.15-unix.tar.gz -q --show-progress

cp 'artifact.php?name=neo4j-enterprise-4.4.15-unix.tar.gz'  neo4j-enterprise-4.4.15-unix.tar.gz && rm 'artifact.php?name=neo4j-enterprise-4.4.15-unix.tar.gz'
tar -xvf neo4j-enterprise-4.4.15-unix.tar.gz

var=$(pwd)
echo "The current working directory $var"

#define filename
cd $var/neo4j-enterprise-4.4.15/conf
filename='neo4j.conf'

# Define ip
ip=$(ip route get 8.8.8.8 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}' | awk '{print $1}')
echo "the ip for Neo4j= $ip"

# Configuration
echo "dbms.security.procedures.unrestricted=apoc.*,gds.*,bloom.*
dbms.security.procedures.allowlist=apoc.*,gds.*,bloom.*
apoc.import.file.enabled=true
apoc.import.file.use_neo4j_config=true
neo4j.bloom.license_file=$var/neo4j-enterprise-4.4.15/licenses/bloom.txt
gds.enterprise.license_file=$var/home/neo4j/neo4j-enterprise-4.4.15/licenses/gds.txt
dbms.unmanaged_extension_classes=com.neo4j.bloom.server=/bloom
dbms.security.http_auth_allowlist=/,/browser.*,/bloom.*
dbms.default_listen_address=0.0.0.0
dbms.default_advertised_address=$ip" >> $filename

# add plugin
cd $var/neo4j-enterprise-4.4.15/plugins
wget https://github.com/neo4j/graph-data-science/releases/download/2.2.6/neo4j-graph-data-science-2.2.6.jar
wget https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/4.4.0.12/apoc-4.4.0.12-all.jar

# start neo4j

cd $var/neo4j-enterprise-4.4.15/bin/
./neo4j start

echo "Neo4j Sucessfuly installed,open your browser inN $ip:7474"
