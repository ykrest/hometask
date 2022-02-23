terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.68.0"
    }
  }
}
provider "aws" {
  region = var.region
}

data "aws_ami" "latest_amazon" {
  owners      = ["137112412989"]
  most_recent = var.ami_linux_recent
  filter {
    name   = "name"
    values = ["al2022-ami-*-kernel-5.10-x86_64"]
  }
}

resource "aws_security_group" "carbyne911" {
  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.common_tags, { Name = "Carbyne911 Security Group" })

}

resource "aws_instance" "my_carbyne_server" {
  ami                    = data.aws_ami.latest_amazon.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.carbyne911.id]
  tags                   = merge(var.common_tags, { Name = "${terraform.workspace}-Carbyne911 Server" })
}

resource "aws_s3_bucket" "carbyne911_s3_bucket" {
  bucket = "my_carbyne_bucket"
  acl    = "private"
}
# ======================= everything after this line was my attempt to introduce environments ===
  
data "aws_availability_zones" "working" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_vpcs" "current" {}

resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = var.region

  tags = {
    Name = "interface"
  }
}

resource "aws_network_interface" "prod" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}
resource "aws_network_interface" "dev" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = ["172.16.10.101"]

  tags = {
    Name = "primary_network_interface"
  }
}
resource "aws_network_interface" "stage" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = ["172.16.10.102"]

  tags = {
    Name = "primary_network_interface"
  }
}
resource "aws_instance" "foo" {
  ami           = data.aws_ami.latest_amazon.id
  instance_type = var.instance_type

  network_interface {
    network_interface_id = aws_network_interface."${terraform.workspace}".id
    device_index         = 0
  }
