#if(( $osgiLevel == "R7" ))
FROM openjdk:9.0.1-11-jre-slim
#else
FROM openjdk:8u151-jre-alpine
#end
LABEL maintainer="Your Name"

ADD target/application.jar /usr/share/server/application.jar
#if(( $osgiLevel == "R7" ))
ENTRYPOINT [ "/usr/bin/java", "--add-opens=java.base/java.net=ALL-UNNAMED", "--add-opens=java.base/java.lang=ALL-UNNAMED", "--add-opens=java.base/jdk.internal.loader=ALL-UNNAMED", "-jar", "/usr/share/server/application.jar" ]
#else
ENTRYPOINT [ "/usr/bin/java", "-jar", "/usr/share/server/application.jar" ]
#end
