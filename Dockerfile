FROM eclipse-temurin:17-alpine as base

WORKDIR /app
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN ./mvnw dependency:resolve
COPY src ./src


FROM base as dev
CMD ["./mvnw", "spring-boot:run", "-Dspring-boot.run.profiles=mysql", "-Dspring-boot.run.jvmArguments='-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8000'"]

FROM base as build
RUN ./mvnw package

FROM eclipse-temurin:17-alpine as prod
EXPOSE 8080
COPY --from=build /app/target/spring-petclinic-*.jar ./spring-petclinic.jar
CMD ["java", "-jar", "spring-petclinic.jar"]
