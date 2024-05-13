FROM maven:3.8.5-openjdk-17 as builder
WORKDIR /authservice
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src/ ./src/
RUN mvn package -DskipTests=true

FROM openjdk:17-jdk-alpine
RUN mkdir /authservice
COPY --from=builder /authservice/target/*.jar /authservice/Auth-Service.jar
ENV SERVER_PORT=8082
WORKDIR /authservice
EXPOSE 8082
ENTRYPOINT ["java", "-jar", "Auth-Service.jar"]