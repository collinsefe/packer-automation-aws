#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
# sudo echo "<h1>Welcome My Good People, Welcome! This server is running on $(hostname -I)</h1>" > /var/www/html/index.html

