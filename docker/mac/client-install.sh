#!/bin/sh
DOCKER_VERSION=1.1.2
DOCKER_URL=http://get.docker.io/builds/Darwin/x86_64/docker-${DOCKER_VERSION}.tgz
DOCKER_FILE=$(basename $DOCKER_URL)

wget $DOCKER_URL
tar xf $DOCKER_FILE
mv usr/local/bin/docker ~/bin/
rmdir -p usr/local/bin
