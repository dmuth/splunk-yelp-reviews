#!/bin/bash
#
# This script downloads reviews from a specified file and then
# starts up Splunk to ingest them.
#

# Errors are fatal
set -e

#
# Things the user can override
#
SPLUNK_PORT=${SPLUNK_PORT:-8000}
SPLUNK_PASSWORD=${SPLUNK_PASSWORD:-password1}
SPLUNK_DATA=${SPLUNK_DATA:-splunk-data}

DOCKER_IT=""
DOCKER_V=""

if test ! "$1" -o "$1" == "-h" -o "$1" == "--help"
then
	echo "! "
	echo "! Syntax: $0 ( --devel | --url URL | file.txt )"
	echo "! "
	echo "! file.txt - File containing one URL per line to download."
	echo "! "
	exit 1
fi

if test ! "$SPLUNK_START_ARGS" -o "$SPLUNK_START_ARGS" != "--accept-license"
then
	echo "! "
	echo "! You need to access the Splunk License in order to continue."
	echo "! "
	echo "! Please restart this container with SPLUNK_START_ARGS set to \"--accept-license\""
	echo "! as follows:"
	echo "! "
	echo "! SPLUNK_START_ARGS=--accept-license"
	echo "! "
fi


if test "$1" == "--devel"
then
	DOCKER_IT="-it"
	DOCKER_V="-v $(pwd)/bin:/app"

elif test "$1" == "--url"
then
	URL=$2

else
	FILE=$1
	if test ! -r $FILE
	then
		echo "! "
		echo "! Unable to read from file '${FILE}'! (Does it exist?)"
		echo "! "
		exit 1
	fi

fi


echo "# "
echo "# Downloading Yelp reviews..."
echo "# "
DOCKER_V_MNT="-v $(pwd):/mnt"
DOCKER_V_LOGS="-v $(pwd)/logs:/logs"
docker run ${DOCKER_IT} ${DOCKER_V} ${DOCKER_V_LOGS} -v $(pwd):/mnt  dmuth1/splunk-yelp-python $@


#
# Create our Docker command line
#
DOCKER_NAME="--name splunk-yelp"
DOCKER_RM="--rm"
DOCKER_V="-v $(pwd)/user-prefs.conf:/opt/splunk/etc/users/admin/user-prefs/local/user-prefs.conf"
DOCKER_PORT="-p ${SPLUNK_PORT}:8000"
DOCKER_LOGS="-v $(pwd)/logs:/logs"
DOCKER_DATA="-v $(pwd)/${SPLUNK_DATA}:/data"

#
# Create our user-prefs.conf which will be pulled into Splunk at runtime
# to set the default app.
#
cat > user-prefs.conf << EOF
#
# Created by Splunk Yelp
#
[general]
default_namespace = search
EOF

echo "# "
echo "# About to run Splunk Yelp!"
echo "# "
echo "# Before we do, please confirm these settings:"
echo "# "
echo "# URL:                               https://localhost:${SPLUNK_PORT}/ (Set with \$SPLUNK_PORT)"
echo "# Login/Password:                    admin/${SPLUNK_PASSWORD} (Set with \$SPLUNK_PASSWORD)"
echo "# Splunk Data Directory:             ${SPLUNK_DATA} (Set with \$SPLUNK_DATA)"
echo "# "

echo "> "
echo "> Press ENTER to run Splunk Yelp with the above settings, or ctrl-C to abort..."
echo "> "
read


CMD="${DOCKER_RM} ${DOCKER_NAME} ${DOCKER_PORT} ${DOCKER_LOGS} ${DOCKER_DATA} ${DOCKER_V}"
CMD="${CMD} -e SPLUNK_START_ARGS=${SPLUNK_START_ARGS}"
CMD="${CMD} -e SPLUNK_PASSWORD=${SPLUNK_PASSWORD}"
CMD="${CMD} -d"

ID=$(docker run $CMD dmuth1/splunk-yelp)

echo "# "
echo "# Splunk Yelp launched with Docker ID: "
echo "# "
echo "# ${ID} "
echo "# "
echo "# To check the logs for Splunk Yelp: docker logs splunk-yelp"
echo "# "
echo "# To kill Splunk Yelp: docker kill splunk-yelp"
echo "# "


