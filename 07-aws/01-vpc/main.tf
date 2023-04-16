resource "aws_vpc" "levelup-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = {
    Name = "levelup-vpc"
  }
}

#Public subnet
resource "aws_subnet" "levelup-vpc-public-subnet-1" {
  vpc_id                  = aws_vpc.levelup-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"

  availability_zone = "ap-south-1a"

  tags = {
    Name = "levelup-vpc-public-1"
  }
}

#Private subnet
resource "aws_subnet" "levelup-vpc-private-subnet-1" {
  vpc_id                  = aws_vpc.levelup-vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "false"

  availability_zone = "ap-south-1a"

  tags = {
    Name = "levelup-vpc-private-1"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "levelup-gw" {
  vpc_id = aws_vpc.levelup-vpc.id
}

# Route table
resource "aws_route_table" "levelup-public" {
  vpc_id = aws_vpc.levelup-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.levelup-gw.id
  }
}

# Route table association
resource "aws_route_table_association" "levelup-public-1-a" {
  subnet_id      = aws_subnet.levelup-vpc-public-subnet-1.id
  route_table_id = aws_route_table.levelup-public.id
}

# EIP

resource "aws_eip" "aws-eip" {
  vpc = true
}

# NAT Gateway
resource "aws_nat_gateway" "levelup-nat-gw" {
  subnet_id = aws_subnet.levelup-vpc-private-subnet-1.id
  allocation_id = aws_eip.aws-eip.id
}

# Private route table
resource "aws_route_table" "levelup-private" {
  vpc_id = aws_vpc.levelup-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.levelup-nat-gw.id
  }
}

resource "aws_route_table_association" "levelup-private-1-a" {
  subnet_id = aws_subnet.levelup-vpc-private-subnet-1.id
  route_table_id = aws_route_table.levelup-private.id
}
