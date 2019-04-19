#!/bin/bash
#
# Download reviews from all of our restaurants
#

# Errors are fatal
set -e

# Change to our main directory
pushd $(dirname $0)/.. > /dev/null


FILE=$(mktemp -t yelp-reviews)
./download-reviews.py https://www.yelp.com/biz/ramen-philadelphia > $FILE
mv $FILE logs/ramen-philadelphia.txt

FILE=$(mktemp -t yelp-reviews)
./download-reviews.py https://www.yelp.com/biz/yanako-philadelphia > $FILE
mv $FILE logs/yanako-philadelphia.txt

FILE=$(mktemp -t yelp-reviews)
./download-reviews.py https://www.yelp.com/biz/chabaa-thai-bistro-philadelphia > $FILE
mv $FILE logs/chabaa-thai-bistro-philadelphia


