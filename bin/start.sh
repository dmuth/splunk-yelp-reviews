#!/bin/bash
#
# Start up Splunk Lab to ingest Yelp data
#


# Errors are fatal
set -e

# 
# Change to the directory of the script
#
pushd $(dirname $0)/.. > /dev/null

if test ! -f "splunk-lab.sh"
then
	echo "# "
	echo "# Downloading splunk-lab.sh..."
	echo "# "
	curl -s https://raw.githubusercontent.com/dmuth/splunk-lab/master/go.sh > splunk-lab.sh
	chmod 755 splunk-lab.sh
fi

export SPLUNK_START_ARGS=--accept-license
export SPLUNK_PORT=8000
#export SPLUNK_BG=0 # Debugging
export DOCKER_NAME=splunk-yelp
export DOCKER_RM=1

./splunk-lab.sh

