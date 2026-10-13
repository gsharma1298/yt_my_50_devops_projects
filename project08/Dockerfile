FROM eclipse-temurin:21-jdk-alpine

WORKDIR /app

COPY src/Main.java .

RUN javac Main.java

EXPOSE 8080

CMD ["java", "Main"]
