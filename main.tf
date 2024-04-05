provider "aws" {
  region = var.aws_region  # Set your desired region
}

data "aws_ami" "default" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]  # Filter to get Amazon Linux 2 AMIs
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"]
}


resource "aws_instance" "ec2" {
    count = var.instance_count
    ami           = data.aws_ami.default.id
    instance_type = var.instance_type
    tags = {
      Name = "${var.instance_name}-${count.index}"
  }
}

variable "aws_region" {
    type = string
    description = "AWS region"
}

variable "instance_type" {
    type = string
    description = "instance type to be created"
}

variable "instance_name" {
    type = string
    description = "Instance name tag"
}

variable "instance_count" {
    type = number
    description = "No of instance to be created" 
    default = 1
}

output "ec2_instance_attributes" {
  description = "Attributes of the EC2 instances"
  value = [
    for instance in aws_instance.ec2 : {
      id           = instance.id
      public_ip    = instance.public_ip
      private_ip   = instance.private_ip
    }
  ]
}

