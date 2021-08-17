#!/bin/bash

sudo yum -y install java-11-openjdk  java-11-openjdk-devel;

cat <<EOF | sudo tee /etc/profile.d/java11.sh
export JAVA_HOME=/usr/lib/jvm/jre-openjdk
export ES_JAVA_HOME=/usr/lib/jvm/jre-openjdk
export PATH=\$PATH:\$JAVA_HOME/bin:\$ES_JAVA_HOME/bin
export CLASSPATH=.:\$JAVA_HOME/jre/lib:\$JAVA_HOME/lib:\$JAVA_HOME/lib/tools.jar
EOF

source /etc/profile.d/java11.sh

#Installing Elasticsearch

rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

cat <<EOF | sudo tee /etc/yum.repos.d/elasticsearch.repo
[elasticsearch]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=0
autorefresh=1
type=rpm-md
EOF

sudo yum clean all
sudo yum makecache

sudo yum install --enablerepo=elasticsearch elasticsearch -y
sudo rpm -qi elasticsearch
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service

##Kibana Installation

rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

cat <<EOF | sudo tee /etc/yum.repos.d/kibana.repo
[kibana-7.x]
name=Kibana repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

sudo yum install -y kibana
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable kibana.service
sudo systemctl start kibana.service
sudo echo 'server.host: "0.0.0.0"' >> /etc/kibana/kibana.yml

#Install Logstash

sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
cat <<EOF | sudo tee /etc/yum.repos.d/logstash.repo
[logstash-7.x]
name=Elastic repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

sudo yum install logstash -y

#BEATS
sudo rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch
cat <<EOF | sudo tee /etc/yum.repos.d/elastic.repo
[elastic-7.x]
name=Elastic repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

sudo yum install -y heartbeat-elastic
sudo systemctl enable heartbeat-elastic
sudo service heartbeat-elastic start
sudo yum -y install metricbeat
sudo systemctl enable metricbeat
sudo service metricbeat start

#Azure logs
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.13.4-x86_64.rpm
sudo rpm -vi filebeat-7.13.4-x86_64.rpm
#enabling azure modules
sudo filebeat modules enable azure
sudo filebeat setup
sudo service filebeat start

