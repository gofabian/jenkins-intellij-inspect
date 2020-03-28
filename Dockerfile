FROM openjdk:11

COPY target/*.jar /app.jar

CMD java -cp /app.jar example.ExampleMain