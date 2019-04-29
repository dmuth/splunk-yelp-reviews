#!/bin/bash
#
# Build our Splunk Yelp Python app
#

# Errors are fatal
set -e

#
# Change to the parent of this script
#
pushd $(dirname $0) > /dev/null
cd ..

echo "# "
echo "# Building Docker container..."
echo "# "
docker build . -t splunk-yelp-python

echo "# Done!"

