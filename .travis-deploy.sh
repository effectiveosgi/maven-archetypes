#!/bin/bash

echo "Preparing for Bintray deployment"

# Get the Java version (Java 1.7 gives "17"")
VER=`java -version 2>&1 | sed 's/java version "\(.*\)\.\(.*\)\..*"/\1\2/; 1q'`
 
if [ $VER == "17" ]; then
    echo "Deploying to Bintray..."
    mvn --settings ./.travis-maven-settings.xml package org.apache.maven.plugins:maven-deploy-plugin:2.8.2:deploy
else
    echo "No action to undertake (not a JDK 7)."
fi