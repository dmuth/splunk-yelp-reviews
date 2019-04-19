#!/usr/bin/env python3
#
# Vim: :set tabstop=4
#
# Download the comments from 1 or more venues in Yelp and write them to stdout
#


import argparse
import logging

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
def parseHtml(html):

	retval = []
	soup = BeautifulSoup(html, 'html.parser')
	
	for review in soup.find_all("div", {"class": "review-content"}):

		row = {}
		
		row["date"] = review.find_all("span", {"class": "rating-qualifier"})[0].text
		row["review"] = review.find_all("p")[0].text

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

	logging.info("Fetching URL: {}...".format(url))
	html = getHtml(url)

	logging.info("Parsing URL: {}...".format(url))
	reviews = parseHtml(html)



def main(args):

	for url in args.urls:
		reviews = getReviews(url)


main(args)
# requirements.txt when done!

