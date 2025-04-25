#! /bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo service httpd start
sudo echo '<h1>Welcome to HTTPD Sever </h1>' | sudo tee /var/www/html/index.html
sudo mkdir /var/www/html/aap1
sudo echo 
