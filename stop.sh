#!/bin/bash

# stop & remove the containers and delete the images
docker compose down
docker compose rm --force

# Ensure all containers are stopped and removed
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)

# Force remove all images
docker rmi -f $(docker images -q)

# delete the cache and the indices
rm -rf data/_state
rm -rf data/indices
rm -rf data/snapshot_cache
rm -rf data/node.lock
rm -rf data/nodes

