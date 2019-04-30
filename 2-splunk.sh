#!/bin/bash
#
# Start up Splunk Lab to ingest Yelp data
#


# Errors are fatal
set -e

export SPLUNK_PORT=8000
#export SPLUNK_BG=0 # Debugging
export DOCKER_NAME=splunk-yelp
export DOCKER_RM=1
export DOCKER_CMD="-v $(pwd)/user-prefs.conf:/opt/splunk/etc/users/admin/user-prefs/local/user-prefs.conf"


bash <(curl -s https://raw.githubusercontent.com/dmuth/splunk-lab/master/go.sh )

