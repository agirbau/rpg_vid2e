#!/bin/bash

# Build docker image
docker build --no-cache -t andreu_rpg_vid2e:latest -f docker_env/Dockerfile .