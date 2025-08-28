#!/bin/bash

# Remove any previous container
docker rm -f andreu_rpg_vid2e 2>/dev/null

# Run container with GPU, port mappings, and mounted volumes
docker run \
    --name andreu_rpg_vid2e \
    --gpus '"device=1"' \
    -it \
    -v /home/andreu/work/projects/research/rpg_vid2e:/home/user/app \
    -v /home/andreu/datasets:/home/user/datasets \
    -v /petaco:/petaco \
    -v /home/andreu/work/andreu_utils:/home/user/global_utils \
    andreu_rpg_vid2e \
    bash -c '
        echo Installing esim_torch...
        pip install /home/user/app/esim_torch
        exec bash
    '