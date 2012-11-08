#!/bin/sh -e
#wget https://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-0.19.8.tar.gz
#tar xzvf elasticsearch-0.19.8.tar.gz

VERSION="0.19.8"
FILE="elasticsearch-${VERSION}.deb"
wget "https://github.com/downloads/elasticsearch/elasticsearch/${FILE}"
sudo dpkg -i "${FILE}"
