FROM maven:3-openjdk-8 AS build
RUN mkdir -p /usr/src/app/
WORKDIR /usr/src/app/
COPY . .
RUN mvn clean install -DskipTests
FROM openjdk:8-jre
COPY --from=build /usr/src/app/microServicesClient/target/dbsnsys-shopping-0.0.1-SNAPSHOT.jar dbsnsys-shopping.jar
EXPOSE 8010
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
