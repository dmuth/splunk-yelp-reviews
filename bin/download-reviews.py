#!/usr/bin/env python3
#
# Vim: :set tabstop=4
#
# Download the comments from 1 or more venues in Yelp and write them to stdout
#


import argparse
import datetime
import json
import logging
import re
import sys

from bs4 import BeautifulSoup
import requests


logging.basicConfig(level = logging.INFO, format='%(asctime)s.%(msecs)03d: %(levelname)s: %(message)s',
	datefmt = '%Y-%m-%d %H:%M:%S'
	)


parser = argparse.ArgumentParser(description = "Download comments from a Yelp page")
parser.add_argument('urls', metavar = 'URL', type = str, nargs = '+',
                    help = '1 or more Yelp URLs to download the comments from')

args = parser.parse_args()


#
# Fetch a specific URL
#
def getHtml(url):

	r = requests.get(url)
	if r.status_code != 200:
		raise Exception("Non-200 HTTP response on URL {}: {}".format(url, r.status_code))

	return(r.text)


#
# Parse HTML from a specific review and return an array of reviews
#
def parseHtml(soup):

	retval = []

	venue = soup.title.text.split(" - ")[0]
	
	for review in soup.find_all("div", {"class": "review-content"}):

		row = {}
		row["venue"] = venue
		
		#
		# Parse our date
		#
		date = review.find_all("span", {"class": "rating-qualifier"})[0].text
		date = re.sub("[^/0-9]", "", date)
		date_time_obj = datetime.datetime.strptime(date, '%m/%d/%Y')
		date = date_time_obj.strftime("%Y-%m-%dT%H:%M:%S.000")

		row["date"] = date


		#
		# Grab our review
		#
		row["review"] = review.find_all("p")[0].text


		#
		# Parse our stars
		#
		stars = review.find_all("div", {"class": "i-stars"})[0]["title"]
		if stars == "5.0 star rating":
			row["stars"] = 5
		elif stars == "4.0 star rating":
			row["stars"] = 4
		elif stars == "3.0 star rating":
			row["stars"] = 3
		elif stars == "2.0 star rating":
			row["stars"] = 2
		elif stars == "1.0 star rating":
			row["stars"] = 1
		else:
			raise Exception("Could not parse 'stars' value: {}".format(stars))

		retval.append(row)

	return(retval)


#
# Download the reviews from a particular venue.
# Additional pages of reviews will be followed. 
#
def getReviews(url):

	retval = []

	while True:

		logging.info("Fetching URL: {}...".format(url))
		html = getHtml(url)
		soup = BeautifulSoup(html, 'html.parser')

		logging.info("Parsing URL: {}...".format(url))
		reviews = parseHtml(soup)
		logging.info("Fetched {} reviews".format(len(reviews)))
		retval = retval + reviews

		next_page = soup.find_all("a", {"class": "next"})
		if next_page:
			url = next_page[0]["href"]
			logging.info("Found next page: {}".format(url))
		else:
			logging.info("No more pages found, bailing out!")
			break

	return(retval)


#
# Print up our reviews as JSON, one event per line.
#
def printReviews(reviews):

	for review in reviews:
		print(json.dumps(review))


#
# Our main entry point.
#
def main(args):

	for url in args.urls:
		reviews = getReviews(url)
		logging.info("Fetched {} reviews in total from URL {}".format(len(reviews), url))
		printReviews(reviews)


main(args)


