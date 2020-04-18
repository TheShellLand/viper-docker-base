#!/bin/bash

# build viper docker

docker build -t theshellland/viper-docker-base $@ -f Dockerfile .
