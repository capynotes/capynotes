FROM maven:3.8.5-openjdk-17 as builder
WORKDIR /noteservice
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src/ ./src/
RUN mvn package -DskipTests=true

FROM openjdk:17-jdk-alpine
RUN mkdir /noteservice
COPY --from=builder /noteservice/target/*.jar /noteservice/Note-Service.jar
ENV SERVER_PORT=8083
WORKDIR /noteservice
EXPOSE 8083
ENTRYPOINT ["java", "-jar", "Note-Service.jar"]