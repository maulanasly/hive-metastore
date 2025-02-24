#!/bin/bash

export HADOOP_HOME=/opt/hadoop-3.2.0
export HADOOP_CLASSPATH=${HADOOP_HOME}/share/hadoop/tools/lib/aws-java-sdk-bundle-1.11.375.jar:${HADOOP_HOME}/share/hadoop/tools/lib/hadoop-aws-3.2.0.jar
export JAVA_HOME=/usr/local/openjdk-8
export METASTORE_DB_HOSTNAME=${METASTORE_DB_HOSTNAME:-localhost}

echo "Waiting for database on ${METASTORE_DB_HOSTNAME} to launch on "${METASTORE_DB_PORT:=5432}" ..."

echo "Database on ${METASTORE_DB_HOSTNAME}:${METASTORE_DB_PORT:=5432} started"
echo "Init apache hive metastore on ${METASTORE_DB_HOSTNAME}:${METASTORE_DB_PORT:=5432}"

/opt/apache-hive-metastore-3.0.0-bin/bin/schematool -initSchema -dbType ${METASTORE_DB_TYPE:=postgres}
/opt/apache-hive-metastore-3.0.0-bin/bin/start-metastore