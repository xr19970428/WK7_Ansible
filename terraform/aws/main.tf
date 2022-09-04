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

data "aws_ami" "image_packer-shell" {
  most_recent = true
  owners = ["self"]
  filter {
    name = "tag:Base_AMI_Name"
    values = ["jiangren-packer-demo-1"]
  }
}

data "aws_ami" "image_packer-ansible" {
  most_recent = true
  owners = ["self"]
  filter {
    name = "tag:Base_AMI_Name"
    values = ["jiangren-packer-demo-2"]
  }
}

resource "aws_instance" "packer-shell" {
  ami           = "${data.aws_ami.image_packer-shell.id}"
  instance_type = "t2.micro"

  tags = {
    Name = "Packer-Shell"
  }
}

resource "aws_instance" "packer-ansible" {
  ami           = "${data.aws_ami.image_packer-ansible.id}"
  instance_type = "t2.micro"

  tags = {
    Name = "Packer-Ansible"
  }
}

