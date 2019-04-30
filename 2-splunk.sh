#!/bin/bash
#
# Start up our Splunk container (an extension of Splunk Lab) to ingest data.
#


# Errors are fatal
set -e

#
# Things the user can override
#
SPLUNK_PORT=${SPLUNK_PORT:-8000}
SPLUNK_DATA=${SPLUNK_DATA:-splunk-data}

#
# Create our Docker command line
#
DOCKER_NAME="--name splunk-yelp"
DOCKER_RM="--rm"
DOCKER_V="-v $(pwd)/user-prefs.conf:/opt/splunk/etc/users/admin/user-prefs/local/user-prefs.conf"
DOCKER_PORT="-p ${SPLUNK_PORT}:8000"
DOCKER_LOGS="-v $(pwd)/logs:/logs"
DOCKER_DATA="-v $(pwd)/${SPLUNK_DATA}:/data"

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



