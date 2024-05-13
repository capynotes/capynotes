FROM maven:3.8.5-openjdk-17 as builder
WORKDIR /gateway
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src/ ./src/
RUN mvn package -DskipTests=true

FROM openjdk:17-jdk-alpine
RUN mkdir /gateway
COPY --from=builder /gateway/target/*.jar /gateway/Gateway.jar
ENV SERVER_PORT=8080
WORKDIR /gateway
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "Gateway.jar"]