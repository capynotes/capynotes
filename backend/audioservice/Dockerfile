FROM openjdk:17
LABEL maintainer="audio-service-image"
ADD target/audioservice-0.0.1-SNAPSHOT.jar Audio-Service.jar
ENTRYPOINT ["java", "-jar", "Audio-Service.jar"]