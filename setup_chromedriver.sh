#!/bin/sh

VERSION='linux64_21.0.1180.4'
FILENAME="chromedriver_${VERSION}.zip"
#URL="http://code.google.com/p/chromedriver/downloads/detail?name=${FILENAME}&can=2&q="
URL="http://chromedriver.googlecode.com/files/${FILENAME}"
wget "${URL}" -O "${FILENAME}"

sudo unzip "${FILENAME}" -d /usr/local/bin/
