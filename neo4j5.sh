#!/bin/bash
## update packages
sudo apt install unzip -y && sudo apt update -y && sudo apt upgrade -y
sudo apt install openjdk-17-jre -y

## Download neo4j packages
wget https://neo4j.com/artifact.php?name=neo4j-enterprise-5.16.0-unix.tar.gz -q --show-progress

# Exstract 
cp 'artifact.php?name=neo4j-enterprise-5.16.0-unix.tar.gz'  neo4j-enterprise-5.16.0-unix.tar.gz && rm 'artifact.php?name=neo4j-enterprise-5.16.0-unix.tar.gz'
tar -xvf neo4j-enterprise-5.16.0-unix.tar.gz

var=$(pwd)
echo "The current working directory $var"

#define filename
cd $var/neo4j-enterprise-5.16.0/conf
echo "apoc.import.file.enabled=true" >> $var/neo4j-enterprise-5.16.0/conf/apoc.conf
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
neo4j.bloom.license_file=$var/neo4j-enterprise-5.16.0/licenses/bloom.txt
gds.enterprise.license_file=$var/home/neo4j/neo4j-enterprise-5.16.0/licenses/gds.txt
dbms.unmanaged_extension_classes=com.neo4j.bloom.server=/bloom
dbms.security.http_auth_allowlist=/,/browser.*,/bloom.*
server.default_listen_address=0.0.0.0
server.default_advertised_address=$ip" >> $filename

# add plugin
cd $var/neo4j-enterprise-5.16.0/plugins
wget https://github.com/neo4j/apoc/releases/download/5.16.1/apoc-5.16.1-core.jar
wget https://graphdatascience.ninja/neo4j-graph-data-science-2.6.0.zip
wget https://neo4j.com/artifact.php?name=neo4j-bloom-2.11.0.zip
wget https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/5.3.1/apoc-5.3.1-extended.jar


## add license
echo "eyJhbGciOiJQUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImZyaW1hbi5zZXRpYXdhbkByc20uaWQiLCJleHAiOjE3MTYzMDM2MDAsImZlYXR1cmVWZXJzaW9uIjoiKiIsIm9yZyI6IkJQSlMgS2V0ZW5hZ2FrZXJqYWFuIiwicHViIjoibmVvNGouY29tIiwicXVhbnRpdHkiOiIxIiwicmVnIjoiRmlybWFuIFNldGlhd2FuIiwic2NvcGUiOiJUcmlhbCIsInN1YiI6Im5lbzRqLWJsb29tLXNlcnZlciIsInZlciI6IioiLCJpc3MiOiJuZW80ai5jb20iLCJuYmYiOjE3MDg1NjU5NzQsImlhdCI6MTcwODU2NTk3NCwianRpIjoiZ0pfNHc2aFNMIn0.CufTFCv298nVoKob0VTt9c44HjiMlMZY6TInbnbjrQKVf0Gn4HDf-0DEVYe0vIMw0K8ceJwlJlLBghsP4wv7y-Hkm0rIJk0Km_oKhjJ2cUmkRe8Q_b7pteKx8OtwSmd2H6RXxkOfw-ElvjWDASDgSiBJLOuFi7L9srv-OP6JCnTq1fBqfxecha6o9TXsQXhQRKxal7Zv5z2JvFAK1JhBy-FmzC2xOW0oXzFwECCguMQPPMUzUfK1nUxrsDDwY7yP8ye059NmNtpJSaz8FHRKBW-3hKP1uJdZcJW6bQBeeGw9IMHTEUgiBaP8yIUPy8GoqLDzwdxuPPKMdSCgy9kG9Q" >> $var/neo4j-enterprise-5.16.0/licenses/bloom.txt
echo "eyJhbGciOiJQUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImZyaW1hbi5zZXRpYXdhbkByc20uaWQiLCJleHAiOjE3MTYzMDM2MDAsImZlYXR1cmVWZXJzaW9uIjoiKiIsIm9yZyI6IkJQSlMgS2V0ZW5hZ2FrZXJqYWFuIiwicHViIjoibmVvNGouY29tIiwicXVhbnRpdHkiOiIxIiwicmVnIjoiRmlybWFuIFNldGlhd2FuIiwic2NvcGUiOiJUcmlhbCIsInN1YiI6Im5lbzRqLWdkcyIsInZlciI6IioiLCJpc3MiOiJuZW80ai5jb20iLCJuYmYiOjE3MDg1NjYwMDUsImlhdCI6MTcwODU2NjAwNSwianRpIjoiMnVYUkx5ZGhuIn0.uPtc-ceAyXt2FRghCDQ2c4Ux_yhAdeN2Mkfuqu6UzpDx6-mxOPg_0Txoj_lbSuv9fUreKWdJSMIhLZ60NsdSsN88hBn4cEd2UZSv4OgvteUa7b2Bd7jmg2GBurBu2wQ6329LG2SwvtkwUgdcv3p_YXAbzHM_HC38AGUr3MATXsZXOyMqEipC4FJOjw-cvE3pGNg9MEc_USV_vuzPyzbWPqa87mX2sIPdhE-AhxacvYQvbmHDIFQrz2Tu3oeHqKFcQ5lTHbC2Ho3UaUrHXJF95nMUxktVAdqMresAKKCjgzzXz9cwsQICFJQcYR7dLkscZjPdkLCUIM2mdlNvPG0qxg" >> $var/neo4j-enterprise-5.16.0/licenses/gds.txt
 

#Accept license
cd $var/neo4j-enterprise-5.16.0/bin/
./neo4j-admin server license --accept-evaluation
# Memory configuration
cd $var/neo4j-enterprise-5.16.0/bin/
./neo4j-admin server memory-recommendation

echo "abis command memory recomendation heapsize nya ditari di conf/neo4j-admin.conf"

#cd $var/neo4j-enterprise-5.16.0/bin/
#./neo4j start
#echo "Neo4j Sucessfuly installed,open your browser in $ip:7474"
