packer {
  required_version = "<=1.9.1"
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

  owners = ["555519622762"]
  most_recent = true
  region = "us-east-1"
}

source "amazon-ebs" "launching" {

  ami_name             = "ami_requirements{{timestamp}}"
  instance_type        = "t2.micro"
  region               = "us-east-1"
  source_ami           = data.amazon-ami.amazonlinux.id
  ssh_username         = "ec2-user"
  communicator         = "ssh"

  force_deregister = false

}


build {
  sources = ["source.amazon-ebs.launching"]

  provisioner "file" {
    source = "Terraform.sh"
    destination = "/home/ec2-user/Terraform.sh"
  }

  provisioner "shell" {

    inline = [
      "sudo yum install git -y",
      "sudo chmod +x /home/ec2-user/Terraform.sh",
      "sudo bash /home/ec2-user/Terraform.sh"
    ]
  }
}
