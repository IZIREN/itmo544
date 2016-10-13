#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y git
sudo apt-get install -y apache2

sudo systemctl enable apache2
sudo systemctl start apache2
sudo git clone https://github.com/maxislash/bootstrap-website

cp -r /bootstrap-website/. /var/www/html/.
