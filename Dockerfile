FROM maven:3.5.0-jdk-8-alpine AS build
RUN mkdir -p /usr/src/app/
WORKDIR /usr/src/app/
COPY . .
RUN mvn -B package --file pom.xml
FROM openjdk:8-jre
COPY --from=build /usr/src/app/target/shopfront-0.0.1-SNAPSHOT.jar dbsnsys-shopping.jar
EXPOSE 8010
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","dbsnsys-shopping.jar"]
