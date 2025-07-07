# VPC
resource "aws_vpc" "runner_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "infra-runner-vpc"
  }
}

# Subnet
resource "aws_subnet" "runner_subnet" {
  vpc_id                  = aws_vpc.runner_vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"
  tags = {
    Name = "infra-runner-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "runner_gw" {
  vpc_id = aws_vpc.runner_vpc.id
  tags = {
    Name = "infra-runner-igw"
  }
}

# Route Table
resource "aws_route_table" "runner_route_table" {
  vpc_id = aws_vpc.runner_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.runner_gw.id
  }
  tags = {
    Name = "infra-runner-route-table"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "runner_route_assoc" {
  subnet_id      = aws_subnet.runner_subnet.id
  route_table_id = aws_route_table.runner_route_table.id
}

# Security Group
resource "aws_security_group" "runner_sg" {
  name        = "infra-runner-sg"
  description = "Allow SSH and GitHub runner traffic"
  vpc_id      = aws_vpc.runner_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # change to office IP or VPN range for security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "infra-runner-sg"
  }
}

# EC2 instance
resource "aws_instance" "github_runner" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.runner_subnet.id
  vpc_security_group_ids = [aws_security_group.runner_sg.id]
  key_name               = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "infra-runner-ec2"
  }
}
