#!/bin/bash

# Errors are fatal
set -e

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

if test "$1" == "--devel"
then
	DOCKER_IT="-it"
	DOCKER_V="-v $(pwd)/bin:/app"

elif test "$1" == "--url"
then
	URL=$2

else
	FILE=$1

fi

DOCKER_V_MNT="-v $(pwd):/mnt"
DOCKER_V_LOGS="-v $(pwd)/logs:/logs"

docker run ${DOCKER_IT} ${DOCKER_V} ${DOCKER_V_LOGS} -v $(pwd):/mnt  dmuth1/splunk-yelp-python $@


