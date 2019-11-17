#FROM alpine/git as clone
#ARG url
#WORKDIR /app
#RUN git clone ${url}

FROM maven:3.2-jdk-8 as build
ARG url
WORKDIR /app
RUN git clone ${url}
ARG project
WORKDIR /app/${project}
#COPY --from=clone /app/${project} /app
RUN mvn package

FROM openjdk:8-jre-alpine
ARG artifactid
ARG version
ARG project
ENV artifact ${artifactid}-${version}.jar
WORKDIR /app
#COPY --from=build /app/target/${artifact} /app
COPY --from=build /app/${project}/target/spring-petclinic-2.2.0.BUILD-SNAPSHOT.jar /app
EXPOSE 8080
ENTRYPOINT ["sh", "-c"]
CMD ["java -jar /app/spring-petclinic-2.2.0.BUILD-SNAPSHOT.jar"]
