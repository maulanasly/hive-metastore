FROM openjdk:8-jre-slim-buster

WORKDIR /opt

ENV HADOOP_VERSION=3.2.0
ENV METASTORE_VERSION=3.0.0
ENV DELTA_CONNECTOR=0.5.0
ENV POSTGRESQL_JDBC_VERSION=42.5.0
ENV LOG4G_VERSION=2.19.0
ENV MYSQL_CONNECTOR_VERSION=8.0.19

RUN apt-get update && apt-get install -y netcat curl

ENV HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION}
ENV HIVE_HOME=/opt/apache-hive-metastore-${METASTORE_VERSION}-bin

RUN curl -L https://downloads.apache.org/hive/hive-standalone-metastore-${METASTORE_VERSION}/hive-standalone-metastore-${METASTORE_VERSION}-bin.tar.gz | tar zxf - && \
    curl -L https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | tar zxf - && \
    curl -L https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.tar.gz | tar zxf - && \
    curl -L https://dlcdn.apache.org/logging/log4j/${LOG4G_VERSION}/apache-log4j-${LOG4G_VERSION}-bin.tar.gz | tar zxf - && \
    curl -L https://github.com/delta-io/connectors/releases/download/v${DELTA_CONNECTOR}/delta-hive-assembly_2.11-${DELTA_CONNECTOR}.jar --output ${HIVE_HOME}/lib/delta-hive-assembly_2.11-${DELTA_CONNECTOR}.jar && \
    curl -L https://jdbc.postgresql.org/download/postgresql-${POSTGRESQL_JDBC_VERSION}.jar --output ${HIVE_HOME}/lib/postgresql-${POSTGRESQL_JDBC_VERSION}.jar && \
    cp mysql-connector-java-${MYSQL_CONNECTOR_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar apache-log4j-${LOG4G_VERSION}-bin/log4j-web-${LOG4G_VERSION}.jar ${HIVE_HOME}/lib/ && \
    rm -rf  mysql-connector-java-${MYSQL_CONNECTOR_VERSION} apache-log4j-${LOG4G_VERSION}-bin

COPY scripts/entrypoint.sh /entrypoint.sh

RUN groupadd -r hive --gid=1000 && \
    useradd -r -g hive --uid=1000 -d ${HIVE_HOME} hive && \
    chown hive:hive -R ${HIVE_HOME} && \
    chown hive:hive /entrypoint.sh && chmod +x /entrypoint.sh

USER hive
EXPOSE 9083

ENTRYPOINT ["sh", "-c", "/entrypoint.sh"]
