#!/bin/bash


echo "Starting EC2 user data setup..."

# Update packages
sudo apt update -y || true

# Install Docker and AWS CLI
sudo apt-get install -y docker.io awscli || true


sudo usermod -aG docker ubuntu

sudo newgrp docker



# Start Docker
systemctl enable docker
systemctl start docker

# Verify installations
docker --version
aws --version

docker rm -f nginx 2>/dev/null || true

docker run -d --name project9 --restart unless-stopped -p 8081:8081 253291597598.dkr.ecr.ap-south-1.amazonaws.com/ecr:18
echo "Docker, AWS CLI, and Nginx setup completed"

