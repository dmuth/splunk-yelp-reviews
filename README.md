
# Splunking Yelp Reviews

Awhile ago, I wanted go out to dinner, but wasn't sure which of a few different
venues I wanted to go to.  They all had high ratings on Yelp, but that didn't
tell the entire story.  So I built this app to Splunk Yelp reviews, which can tell you:

- Avg ratings/number of ratings over time
- Most 5 recent positive/negative reviews
- Tag cloud of words from positive/negative reviews

In real-life, I've used this app to see what the biggest complaints are
about a venue (ordering over the phone), and since they didn't apply to me, 
decide I still wanted to eat there.

This app uses <a href="https://github.com/dmuth/splunk-lab">Splunk Lab</a>, an open-source 
app I built to effortlessly run Splunk in a Docker container.


## Requirements

- Docker
- Python 3


## Installation

- `pip3 install -r ./requirements.txt` - Install required Python modules
- `./bin/download-reviews.sh ./urls.txt` - Download reviews from Yelp. Change `urls.txt` with URLs for different venues on Yelp as needed.
- `SPLUNK_PASSWORD=password1 SPLUNK_START_ARGS=--accept-license ./bin/start.sh` - Start Splunk!
- Go to <a href="https://localhost:8000/">https://localhost:8000/</a>, log in with the 
password you set, and you're in!

When done, run `./bin/stop.sh` or `./bin/clean.sh` to stop Splunk or clean up.



