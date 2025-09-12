FROM eclipse-temurin:21-jdk-alpine AS build
WORKDIR /build
COPY gradlew .
COPY gradle gradle/
COPY build.gradle settings.gradle ./
RUN chmod +x gradlew
RUN ./gradlew dependencies --no-daemon || true
COPY src src/
RUN ./gradlew clean build -x test --no-daemon

FROM eclipse-temurin:21-jdk-alpine
ARG JAR_FILE=/build/build/libs/*.jar
RUN mkdir -p /opt/docker-test
COPY --from=build ${JAR_FILE} /opt/docker-test/app.jar
ENTRYPOINT ["java", "-jar", "/opt/docker-test/app.jar"]
