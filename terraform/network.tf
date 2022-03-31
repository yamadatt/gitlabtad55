variable "vpc_cidr" {
  description = "The CIDR block of the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "radio-vpc"
  }

}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "radio-igw"
  }
}


# Subnet(Public)
resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 0) # 10.0.0.0/24
  map_public_ip_on_launch = true

  tags = {
    "Name" = "radio-public-subnet-1a"
  }
}

# Route Table(Public)

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "public-route"
  }
}

resource "aws_route" "to_internet" {
  route_table_id         = aws_route_table.public_rt.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_rt_1a" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.public_rt.id
}

