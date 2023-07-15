resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "${var.APP_NAME}-vpc"
    Environment = "${var.Environment}"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "${var.AWS_REGION}a"

  tags = {
    Name        = "${var.APP_NAME}-public-subnet-1"
    Environment = var.Environment
  }
}

resource "aws_subnet" "public_subent_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.AWS_REGION}c"

  tags = {
    Name        = "${var.APP_NAME}-public-subnet-2"
    Environment = var.Environment
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "${var.AWS_REGION}a"

  tags = {
    Name        = "${var.APP_NAME}-private-subnet-1"
    Environment = var.Environment
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "${var.AWS_REGION}c"

  tags = {
    Name        = "${var.APP_NAME}-private-subnet-2"
    Environment = var.Environment
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.APP_NAME}-igw"
    Environment = var.Environment
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

