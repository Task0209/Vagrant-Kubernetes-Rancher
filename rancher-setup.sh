#!/bin/bash

sudo -i -u ubuntu

docker run -d --restart=unless-stopped \
-p 80:80 -p 443:443 \
-v /opt/rancher:/var/lib/rancher \
--privileged \
rancher/rancher:latest
