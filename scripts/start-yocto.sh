#!/bin/bash -xe

sudo -s
apt-get update && apt-get -y upgrade
apt-get -y install docker.io

docker run -dp 8080:8080 felixb/yocto-httpd
