packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "aws" {
  ami_name      = "jiangren-packer-demo-2-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "ap-southeast-2"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
  ssh_private_key_file = file("/var/lib/jenkins/.ssh/id_rsa.pub")
  tags = {
    Base_AMI_Name  = "jiangren-packer-demo-2"
  }
}

build {
  name = "jiangren-packer-demo-2"
  sources = [
    "source.amazon-ebs.aws"
  ]
  provisioner "ansible" {
    playbook_file = "./playbook.yml"
  }

}
