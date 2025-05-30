FROM openjdk:17-jdk-slim
ENV APP_NAME java-maven-0.0.1-SNAPSHOT.war
WORKDIR /app
COPY target/${APP_NAME} /app/${APP_NAME}
EXPOSE 8080  
ENTRYPOINT ["java", "-jar", "java-maven-0.0.1-SNAPSHOT.war"]
