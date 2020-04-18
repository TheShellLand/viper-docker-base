#!/bin/bash

# build viper docker

docker build -t viper-docker-base $@ -f Dockerfile .
