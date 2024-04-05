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

output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.ec2.id
}

output "ec2_instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.ec2.public_ip
}

output "ec2_instance_private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = aws_instance.ec2.private_ip
}
