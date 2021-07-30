#!/bin/bash

echo $1 | sudo -S -k yum -y install java-1.8.0-openjdk  java-1.8.0-openjdk-devel;

cat <<EOF | sudo -S tee /etc/profile.d/java8.sh
export JAVA_HOME=/usr/lib/jvm/jre-openjdk
export PATH=\$PATH:\$JAVA_HOME/bin
export CLASSPATH=.:\$JAVA_HOME/jre/lib:\$JAVA_HOME/lib:\$JAVA_HOME/lib/tools.jar
EOF

source /etc/profile.d/java8.sh

cat <<EOF | sudo -S tee /etc/yum.repos.d/elasticsearch.repo
[elasticsearch-7.x]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/oss-7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

echo $1 | sudo -S -k yum clean all
echo $1 | sudo -S - k yum makecache

echo $1 | sudo -S -k yum -y install elasticsearch-oss

rpm -qi elasticsearch-oss
