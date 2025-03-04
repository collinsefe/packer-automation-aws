# Create a VPC
resource "aws_vpc" "packer" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "packer-vpc"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "packer" {
  vpc_id = aws_vpc.packer.id

  tags = {
    Name = "packer-igw"
  }
}

# Create a Public Subnet
resource "aws_subnet" "packer" {
  vpc_id                  = aws_vpc.packer.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-2a" # Adjust if necessary
  map_public_ip_on_launch = true

  tags = {
    Name = "packer-public-subnet"
  }
}

# Create a Route Table for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.packer.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.packer.id
  }

  tags = {
    Name = "packer-public-route-table"
  }
}

# Associate the Route Table with the Public Subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.packer.id
  route_table_id = aws_route_table.public.id
}

# Create a Security Group for the EC2 Instances
resource "aws_security_group" "packer" {
  name        = "packer-instance-sg"
  description = "Security group for Packer-managed EC2 instances"
  vpc_id      = aws_vpc.packer.id


   # Ingress rule for WinRM over HTTP (port 5985)
  ingress {
    from_port   = 5985
    to_port     = 5985
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow from any IP (restrict this in production)
    description = "Allow WinRM over HTTP"
  }

  # Ingress rule for WinRM over HTTPS (port 5986)
  ingress {
    from_port   = 5986
    to_port     = 5986
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow from any IP (restrict this in production)
    description = "Allow WinRM over HTTPS"
  }

  # Allow inbound traffic on SSH for debugging (optional)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound traffic on SSH for debugging (optional)
  ingress {
    from_port   = 0
    to_port     = 9900
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "packer-instance-sg"
  }
}
