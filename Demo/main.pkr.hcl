packer {
  required_version = "<=1.9.2"
  required_plugins {
    amazon = {
      version = ">= 1.2.5"
      source = "github.com/hashicorp/amazon"
    }
  }
}


data "amazon-ami" "amazonlinux" {
  filters = {
      virtualization-type = "hvm"
      name = "base-image"
      root-device-type = "ebs"
  }

  owners = ["PUT AWS ACCOUNT ID"] 
  most_recent = true
  region = "us-east-1"
}

variable "commit_id" {
  type = string
  default = ""
}

source "amazon-ebs" "launching" {

  ami_name             = "demo_ami.${var.commit_id}"
  instance_type        = "t2.micro"
  region               = "us-east-1"
  source_ami           = data.amazon-ami.amazonlinux.id
  ssh_username         = "ec2-user"
  communicator         = "ssh"

  force_deregister = false

}


build {
  sources = ["source.amazon-ebs.launching"]
    
    // provisioner "file" {
    // source = "apache.sh"
    // destination = "/home/ec2-user/"
    // }

    provisioner "shell" {
      script = "apache.sh"
    }
}