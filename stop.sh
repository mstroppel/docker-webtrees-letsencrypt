#!/bin/bash

#
# This file should be used to stop your webtrees.
#

# 1. Check if .env file exists
if [ -e .env ]; then
    source .env
else 
    echo "Please set up your .env file before starting your environment."
    exit 1
fi

# 2. Stop containers
docker-compose down

exit 0
