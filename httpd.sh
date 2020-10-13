#!/bin/bash
sudo apt-get -y install httpd
echo "<p> My Instance! </p>" >> /var/www/html/index.html
sudo systemctl enable httpd
sudo systemctl start httpd