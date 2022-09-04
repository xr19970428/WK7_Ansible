terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "ap-southeast-2"
}

resource "aws_key_pair" "deployer" {
  key_name   = "ansible-deployer-key"
  public_key = file("/var/lib/jenkins/.ssh/id_rsa.pub")
}

resource "aws_instance" "ansible-aws" {
  ami           = "ami-0e040c48614ad1327" //ubuntu-22.04
  instance_type = "t2.micro"

  tags = {
    Name = "Ansible-AWS"
  }
}

