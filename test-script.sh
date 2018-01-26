#!/usr/bin/env bash

set -e

ARCHETYPES_VERSION=0.0.5

TARGET_DIR=$(pwd)/target
PREFIX_DIR=${TARGET_DIR}/test_
LOGFILE=${TARGET_DIR}/test.log

GROUP_ID=org.example
PARENT_ARTIFACT_ID=${GROUP_ID}.parent
MODULE_ARTIFACT_ID=${GROUP_ID}.module
TEST_MODULE_ARTIFACT_ID=${MODULE_ARTIFACT_ID}.test
STANDALONE_MODULE_ARTIFACT_ID=${GROUP_ID}.standalone
VERSION=1.0-SNAPSHOT

function runtests() {
	mkdir -p $TARGET_DIR

	echo STARTING $1 TEMPLATE CHECKS
	echo ===========================
	ORIGINAL_DIR=$(pwd)

	# Clean and recreate test folder
	rm -rf ${PREFIX_DIR}${1}
	mkdir -p ${PREFIX_DIR}${1}
	cd ${PREFIX_DIR}${1}

	echo '>>>'  Generating top-level project ${PARENT_ARTIFACT_ID}
	mvn -B archetype:generate \
		-DarchetypeGroupId=com.effectiveosgi \
		-DarchetypeVersion=${ARCHETYPES_VERSION} \
		-DarchetypeArtifactId=eosgi-project-archetype \
		-DgroupId=${GROUP_ID} \
		-DartifactId=${PARENT_ARTIFACT_ID} \
		-Dversion=${VERSION} \
		-DosgiLevel=${1}
	cd ${PARENT_ARTIFACT_ID}
	echo '>>>'  Building top-level project... 
	mvn clean verify

	# Generate module
	echo '>>>'  Generating child module ${MODULE_ARTIFACT_ID}
	mvn -B archetype:generate \
		-DarchetypeGroupId=com.effectiveosgi \
		-DarchetypeVersion=${ARCHETYPES_VERSION} \
		-DarchetypeArtifactId=eosgi-module-archetype \
		-DgroupId=${GROUP_ID} \
		-DartifactId=${MODULE_ARTIFACT_ID} \
		-Dversion=${VERSION} \
		-DosgiLevel=${1}

	# Insert new module into _index/pom.xml
	echo '>>>'  Inserting new module ${MODULE_ARTIFACT_ID} into _index/pom.xml
	sed -i.bak -e 's|<!-- Workspace Dependencies -->|&\
		<dependency>\
		<groupId>'${GROUP_ID}'</groupId>\
		<artifactId>'${MODULE_ARTIFACT_ID}'</artifactId>\
		<version>'${VERSION}'</version>\
		</dependency>\
	|' _index/pom.xml

	# Insert new module to _assembly/application.bndrun
	echo '>>>'  Inserting new module ${MODULE_ARTIFACT_ID} into _assembly/application.bndrun
	sed -i.bak -e 's|-runrequires: |&bnd.identity;id='${MODULE_ARTIFACT_ID}', |' _assembly/application.bndrun

	# Build before resolving, this should fail
	echo '>>>'  Building project with child module '(pre-resolve, should fail)'
	if mvn clean verify; then
		echo ERROR: Build should NOT have succeeded before resolve
		exit 1
	fi

	# Resolve and rebuild
	echo '>>>'  Resolving _assembly/application.bndrun
	java -jar $2 resolve resolve -Wb _assembly/application.bndrun
	echo '>>>'  Building project with child module '(post-resolve, should pass)'
	mvn clean verify

	# Generate test module
	echo '>>>'  Generating child test module ${TEST_MODULE_ARTIFACT_ID}
	mvn -B archetype:generate \
		-DarchetypeGroupId=com.effectiveosgi \
		-DarchetypeVersion=${ARCHETYPES_VERSION} \
		-DarchetypeArtifactId=eosgi-test-module-archetype \
		-DgroupId=${GROUP_ID} \
		-DartifactId=${TEST_MODULE_ARTIFACT_ID} \
		-Dversion=${VERSION} \
		-DosgiLevel=${1}

	# Build with test module
	echo '>>>'  Building project with test module
	mvn clean verify

	# Generate standalone module
	echo '>>>'  Generating standalone module ${STANDALONE_MODULE_ARTIFACT_ID}
	cd ..
	mvn -B archetype:generate \
		-DarchetypeGroupId=com.effectiveosgi \
		-DarchetypeVersion=${ARCHETYPES_VERSION} \
		-DarchetypeArtifactId=eosgi-module-archetype \
		-DgroupId=${GROUP_ID} \
		-DartifactId=${STANDALONE_MODULE_ARTIFACT_ID} \
		-Dversion=${VERSION} \
		-DosgiLevel=${1}

	# Build standalone module
	cd ${STANDALONE_MODULE_ARTIFACT_ID}
	echo '>>>' Building standalone module ${STANDALONE_MODULE_ARTIFACT_ID}
	mvn clean verify

	cd $ORIGINAL_DIR
}

BND3_PATH=$(pwd)/.travis/bnd-3.5.0.jar
BND4_PATH=$(pwd)/.travis/bnd-4.0.0.201712272121-SNAPSHOT.jar

runtests R6 $BND3_PATH
runtests R7 $BND4_PATH

echo TESTS PASSED
