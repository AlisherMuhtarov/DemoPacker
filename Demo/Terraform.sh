#!/bin/bash

# Install yum-utils
sudo yum install -y yum-utils

# Add HashiCorp repository to yum configuration
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

# Install Terraform
sudo yum -y install terraform

# Verify Terraform installation
terraform --version
