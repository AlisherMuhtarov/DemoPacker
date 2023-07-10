# Input File
variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "ssh_user" {
  type    = string
  default = "ec2-user"
}

variable "communicator" {
  type    = string
  default = "ssh"
}
