#!/bin/bash

echo "spring.datasource.driver-class-name=com.mysql.jdbc.Driver" >> application.properties
echo "spring.datasource.url=jdbc:mysql://${DB_INTERNAL_IP_ADDRESS}/${DB_NAME}?createDatabaseIfNotExist=true&useUnicode=true&characterEncoding=utf8" >> application.properties
echo "spring.datasource.username=${DB_USERNAME}" >> application.properties
echo "spring.datasource.password=${DB_PASSWORD}" >> application.properties
echo "spring.jpa.properties.hibernate.show_sql=true" >> application.properties
echo "spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect" >> application.properties
echo "spring.jpa.hibernate.ddl-auto=update" >> application.properties
echo "spring.datasource.hikari.connection-timeout=2000" >> application.properties
echo "logging.level.org.springframework.validation=DEBUG" >> application.properties
echo "spring.jackson.deserialization.fail-on-unknown-properties=true" >> application.properties
echo "pubsub.projectId=${PROJECT_ID}" >> application.properties
echo "pubsub.topicId=${TOPIC_ID}" >> application.properties
ls -al >>debug.txt
sudo chown csye6225:csye6225 application.properties
sudo mv application.properties ${location}