#if(( $osgiLevel == "R7" ))
FROM openjdk:9.0.1-11-jre-slim
#else
FROM openjdk:8u151-jre-alpine
#end
LABEL maintainer="Your Name"

ADD target/application.jar /usr/share/server/application.jar
ENTRYPOINT [ "/usr/bin/java", "-jar", "/usr/share/server/application.jar" ]