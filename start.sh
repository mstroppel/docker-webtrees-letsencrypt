#!/bin/bash

#
# This file should be used to prepare and run your webtrees image after set up your .env file
#

# 1. Check if .env file exists
if [ -e .env ]; then
    source .env
else 
    echo "It seems you didn´t create your .env."
    exit 1
fi

# 2. Update local images
docker-compose pull

# 3. Start nextcloud
docker-compose up -d

exit 0
