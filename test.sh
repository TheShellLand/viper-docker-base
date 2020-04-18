#!/bin/bash

# test viper docker

set -xe

docker run --rm -it theshellland/viper-docker-base $@
