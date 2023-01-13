#!/bin/bash
## update packages
sudo apt install openjdk-17-jre -y

## Download neo4j packages
wget https://neo4j.com/artifact.php?name=neo4j-enterprise-5.3.0-unix.tar.gz -q --show-progress

# Exstract 
cp 'artifact.php?name=neo4j-enterprise-5.3.0-unix.tar.gz'  neo4j-enterprise-5.3.0-unix.tar.gz && rm 'artifact.php?name=neo4j-enterprise-5.3.0-unix.tar.gz'
tar -xvf neo4j-enterprise-5.3.0-unix.tar.gz

var=$(pwd)
echo "The current working directory $var"

#define filename
cd $var/neo4j-enterprise-5.3.0/conf
filename='neo4j.conf'

# Define ip
ip=$(ip route get 8.8.8.8 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}' | awk '{print $1}')
echo "the ip for Neo4j= $ip"

# Configuration
echo "server.config.strict_validation.enabled=false
server.directories.import=import
dbms.security.procedures.unrestricted=apoc.*,gds.*,bloom.*
dbms.security.procedures.allowlist=apoc.*,gds.*,bloom.*
apoc.import.file.enabled=true
apoc.import.file.use_neo4j_config=true
neo4j.bloom.license_file=$var/neo4j-enterprise-5.3.0/licenses/bloom.txt
gds.enterprise.license_file=$var/home/neo4j/neo4j-enterprise-5.3.0/licenses/gds.txt
dbms.unmanaged_extension_classes=com.neo4j.bloom.server=/bloom
dbms.security.http_auth_allowlist=/,/browser.*,/bloom.*
dbms.default_listen_address=0.0.0.0
dbms.default_advertised_address=$ip" >> $filename

# add plugin
cd $var/neo4j-enterprise-5.3.0/plugins
wget https://github.com/neo4j/graph-data-science/releases/download/2.2.6/neo4j-graph-data-science-2.2.6.jar
wget https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/5.3.1/apoc-5.3.1-extended.jar


## add license
echo "eyJhbGciOiJQUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6Im1lc2EuZHlhc3RhbWFAcGVydXJpLmNvLmlkIiwiZXhwIjoxNjczOTY3NjAwLCJmZWF0dXJlVmVyc2lvbiI6IioiLCJvcmciOiJQVC4gUGVnYWRpYWFuIChQZXJzZXJvKSIsInB1YiI6Im5lbzRqLmNvbSIsInF1YW50aXR5IjoiMSIsInJlZyI6Ik1lc2EgRHlhc3RhbWEiLCJzY29wZSI6IlRyaWFsIiwic3ViIjoibmVvNGotYmxvb20tc2VydmVyIiwidmVyIjoiKiIsImlzcyI6Im5lbzRqLmNvbSIsIm5iZiI6MTY3MTQyMTY2NywiaWF0IjoxNjcxNDIxNjY3LCJqdGkiOiJwSl9iLTI2UlcifQ.hR-FrXA0YfqBw7x2tblDMD3LY6gNnMIKmXC5abYEi9WKZG0e8kePtx7LVLKlqzAZ_JrldJH39K-XU-0vxy6rWnwEOjbLpxuhTK5mw4teyi08vy3HC8hcyVy70TXpzVbPBBSENWK62rOsYBVQWGPP9_k590LDsjSqrr9OROEM2G5-ZCn1yB6m7vRomo_h1yNmdl8Ytd9dw5ifJrudIcJpUnoWVehBV8fpa5_STvPkkdMjBDE4aAQ7gNnQCVp-q7xvoL-SUBj0CqGLAQfdDoKiXWs3XJLddkPMHjTAc-R04AMS0WqYwJoEIkpRGgcLWOMfYy6F1mnI8uWULK5Ga8Gx8w" >> $var/neo4j-enterprise-5.3.0/licenses/bloom.txt
echo "eyJhbGciOiJQUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6Im1lc2EuZHlhc3RhbWFAcGVydXJpLmNvLmlkIiwiZXhwIjoxNjczOTY3NjAwLCJmZWF0dXJlVmVyc2lvbiI6IioiLCJvcmciOiJQVC4gUGVnYWRpYWFuIChQZXJzZXJvKSIsInB1YiI6Im5lbzRqLmNvbSIsInF1YW50aXR5IjoiMSIsInJlZyI6Ik1lc2EgRHlhc3RhbWEiLCJzY29wZSI6IlRyaWFsIiwic3ViIjoibmVvNGotZ2RzIiwidmVyIjoiKiIsImlzcyI6Im5lbzRqLmNvbSIsIm5iZiI6MTY3MTQyMTY5OCwiaWF0IjoxNjcxNDIxNjk4LCJqdGkiOiJZa2hHYWwxVy0ifQ.vFEw8ImpWicdcPtOzJSoK-sqXKjK3dmGl9HL13qkq1Kch18jnS9sID9OV1XDXTVCbqelT1ht51KmCCp3P0EdGYtU2Qoobjm4oJqGjH7KYlqfHQaxTaQJRv_B6A2ooFlzOX9VuHExSPa5puDzcoGBtGz8zWedahEn8mD2U9FbdPd3DM51SfE8RVLJ4Yvc1gOMlmol4HHUdYb8PK6zPJXD_2KQiNT-apXynjIreaQ5nN0_wG1Ze-mczZT6WUP33me5o-GrdG9kj3ZmSXGMv76JsmZvV1DylQMu7uHrTnF6KsFNmiAwf_jKkV1gY2TNbmcHFLhftTeCasQavShEg3PASQ" >> $var/neo4j-enterprise-5.3.0/licenses/gds.txt
 

echo "Neo4j Sucessfuly installed,open your browser in $ip:7474"

# Memory configuration
cd $var/neo4j-enterprise-5.3.0/bin/
./neo4j-admin server memory-recommendation

cd $var/neo4j-enterprise-5.3.0/bin/
./neo4j start
echo "Neo4j Sucessfuly installed,open your browser in $ip:7474"
