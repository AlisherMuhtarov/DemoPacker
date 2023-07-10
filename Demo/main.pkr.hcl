packer {
  required_version = "<=1.9.1" # Specifies the required version of Packer.
  required_plugins {
    amazon = { # Specifies the required Amazon plugin.
      version = ">= 1.2.5"
      source = "github.com/hashicorp/amazon"
    }
  }
}

include {
  files = [
    "variables.pkr.hcl"
  ]
}

data "amazon-ami" "amazonlinux" { # Data source for retrieving information about an Amazon Machine Image 
  filters = {
      virtualization-type = "hvm"
      name = "base-image"
      root-device-type = "ebs"
  }

  owners = ["555519622762"]
  most_recent = true
  region = "us-east-1"
}

source "amazon-ebs" "launching" { # Specifies the details of the EBS volume to be used for building the AMI

  ami_name             = "MY-DEMO-AMI-{{timestamp}}"
  instance_type        = var.instance_type
  region               = var.region
  source_ami           = data.amazon-ami.amazonlinux.id
  ssh_username         = var.ssh_user
  communicator         = var.communicator

  force_deregister = false

}


build { # Defines the build process and includes the sources and provisioners.
  sources = ["source.amazon-ebs.launching"]

  provisioner "file" { # Used to copy a file from the local machine to the remote instance being built.
    source = "Terraform.sh"
    destination = "/home/ec2-user/Terraform.sh"
  }

  provisioner "shell" { # Used to execute shell commands on the remote instance.

    inline = [
      "sudo yum install git -y",
      "sudo chmod +x /home/ec2-user/Terraform.sh",
      "sudo bash /home/ec2-user/Terraform.sh"
    ]
  }
}
