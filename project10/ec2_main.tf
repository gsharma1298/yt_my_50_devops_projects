
provider "aws" {
  region = "ap-south-1"
}

# Get Default VPC
data "aws_vpc" "default" {
  default = true
}

# Get Default Security Group
data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}

# Create EC2 Instance
resource "aws_instance" "server" {
  ami                    = "ami-0c7632fb77f35db43"
  instance_type          = "t3.micro"
  key_name               = "key"
  vpc_security_group_ids = [data.aws_security_group.default.id]

  tags = {
    Name = "server"
  }
}
