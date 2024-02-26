FROM maven:3.8.5-openjdk-17 as builder
WORKDIR /notificationservice
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src/ ./src/
RUN mvn package -DskipTests=true

FROM openjdk:17-jdk-alpine
RUN mkdir /notificationservice
COPY --from=builder /notificationservice/target/*.jar /notificationservice/Notification-Service.jar
ENV SERVER_PORT=8081
WORKDIR /notificationservice
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "Notification-Service.jar"]