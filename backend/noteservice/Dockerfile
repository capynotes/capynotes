# Stage 1: Build the application with Maven
FROM maven:3.8.5-openjdk-17 as builder
WORKDIR /noteservice

# Copy the pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code and package the application
COPY src/ ./src/
RUN mvn package -DskipTests=true

# Stage 2: Create the final image
FROM openjdk:17-jdk-alpine
WORKDIR /noteservice

# Copy the packaged application from the builder stage
COPY --from=builder /noteservice/target/*.jar /noteservice/Note-Service.jar

# Copy the resources separately if they are not in the JAR
COPY src/main/resources /noteservice/resources

ENV SERVER_PORT=8083
EXPOSE 8083

ENTRYPOINT ["java", "-jar", "Note-Service.jar"]
