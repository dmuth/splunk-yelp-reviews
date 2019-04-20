#!/bin/bash
#
# Download reviews from all of our restaurants
#

# Errors are fatal
set -e

# Change to our main directory
pushd $(dirname $0)/.. > /dev/null

for URL in $(cat urls.txt)
do
	TARGET=logs/$(echo $URL | sed -e "s/.*\///").json
	if test -f $TARGET
	then
		echo "# Target '${TARGET}' exists, skipping..."
	fi

	TMP=$(mktemp -t yelp-reviews)
	./download-reviews.py $URL > $TMP
	mv $TMP $TARGET
done



