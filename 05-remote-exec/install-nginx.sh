#!/bin/bash

# sleep until instance is ready
until [ -f /var/lib/cloud/instance/boot-finished ]; do
    sleep 1
done

# install nginx
sudo apt update
sudo apt install -y nginx

# make sure nginx is started
sudo service nginx start

echo "Hello world"