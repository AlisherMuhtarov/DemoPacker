#!/bin/bash

# Update package lists
sudo yum update -y

# Install Apache
sudo yum install httpd -y

# Start Apache service
sudo systemctl start httpd

# Enable Apache to start on boot
sudo systemctl enable httpd

# Create the index.html file with the specified content
echo "this is the third ami" | sudo tee /var/www/html/index.html

echo "Apache installed and index.html created!"