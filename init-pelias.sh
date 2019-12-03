#!/bin/bash
set -x

mkdir /data /code

# set proper permissions. make sure the user matches your `DOCKER_USER` setting in `.env`
chown -R 1000:1000 /code /data

# clone repo
cd /code
git clone git@bitbucket.org:prototypdigital/digitransit-pelias.git
cd digitransit-pelias

# install pelias script
ln -s "$(pwd)/pelias" /usr/local/bin/pelias

# cwd
cd projects/osijek

# configure environment
sed -i '/DATA_DIR/d' .env
echo 'DATA_DIR=/data' >> .env

# run build
pelias compose pull
pelias elastic start
pelias elastic wait
pelias elastic create
pelias download osm
mv /data/openstreetmap/croatia-latest.osm.pbf /data/openstreetmap/croatia.osm.pbf 
pelias prepare all
pelias import osm
pelias compose up
