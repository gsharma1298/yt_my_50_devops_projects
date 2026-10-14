
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# Get the existing default VPC
data "aws_vpc" "default" {
  default = true
}

# Get the existing default security group
data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}

# Get default subnets in the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

# IAM role for EC2
resource "aws_iam_role" "ecr_role" {
  name = "project09-ec2-ecr-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach ECR full access
resource "aws_iam_role_policy_attachment" "ecr_full_access" {
  role       = aws_iam_role.ecr_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

# Instance profile
resource "aws_iam_instance_profile" "ecr_profile" {
  name = "project09-ec2-ecr-profile"
  role = aws_iam_role.ecr_role.name
}

# Create EC2 instance
resource "aws_instance" "project09" {
  ami                    = "ami-01a00762f46d584a1"
  instance_type          = "c7i-flex.large"
  subnet_id              = sort(data.aws_subnets.default.ids)[0]
  vpc_security_group_ids = [data.aws_security_group.default.id]

  iam_instance_profile = aws_iam_instance_profile.ecr_profile.name
  user_data             = file("./userdata.sh")

  tags = {
    Name    = "project09"
    Project = "HR82DevOps"
  }

  depends_on = [
    aws_iam_role_policy_attachment.ecr_full_access
  ]
}

output "instance_id" {
  value = aws_instance.project09.id
}

output "public_ip" {
  value = aws_instance.project09.public_ip
}

output "default_vpc_id" {
  value = data.aws_vpc.default.id
}

output "default_security_group_id" {
  value = data.aws_security_group.default.id
}
