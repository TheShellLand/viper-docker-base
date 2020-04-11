#!/bin/bash

# test viper docker

set -xe

docker run --rm -it viper-docker-base $@
