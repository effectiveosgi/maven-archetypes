
VERSION=3.13.0.v20171215-2014
mvn deploy:deploy-file \
    -DgroupId=org.eclipse.platform \
    -DartifactId=org.eclipse.osgi \
    -Dversion=${VERSION} \
    -Durl=file:./local-maven-repo \
    -DrepositoryId=local-maven-repo \
    -DupdateReleaseInfo=true \
    -Dfile=local-maven-repo/org.eclipse.osgi_${VERSION}.jar