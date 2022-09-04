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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC3WyxM6S/FqdbX5YRWqx7w3mdr5mLFmZTpM8X3JcjPAcG490ex50sHKqcJVK8EV+rAgKJvgJp2DI9PM4WvtC8/ai++22Pyh7q4UwJg60V1cLPLTaMXT9SRVppW4VguopseXhIrYdZVsD+C9hzIZSXD8KmrBJh593iUkkO8SINddeEN/escY3pCcNFkYTZMs69twOvmjq9qA7bFkkI8ZmdHZNwYPTSpxoC0O0cQAWpR3vZFexWPSeOMK5Bl0LET4ZB4b/xGwLsUnFBSD+Ghwsc6tT6J+sb/B7vq4va9wvPtKDPfiQ9o58pt9AD1gR/cSNEQ76kTcODVb8DLAkNKZqfj3uu5LVNIQD/6Da4Sgk7NLlQ5g8Xq3TF/1dnKB3+ZbpFeOfIwFUGV/RPKhgqYafKU0YJM9uhGsH/oIH+m10YLu860i9EwGLi2XJhB9SagC2SEtG/r58nDOBwFN7hAvL/y4V39NlLkieT/ZcHmu3DjQLycU8Dmt6Tz1RAn1sxe388= root@Jenkins-Server"
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
  key_name = "${aws_key_pair.deployer.key_name}"

  tags = {
    Name = "Packer-Shell"
  }
}

resource "aws_instance" "packer-ansible" {
  ami           = "${data.aws_ami.image_packer-ansible.id}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.deployer.key_name}"

  tags = {
    Name = "Packer-Ansible"
  }
}

