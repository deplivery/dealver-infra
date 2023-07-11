resource "aws_vpc" "ecr_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.ecr_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "ap-northeast-2a"
}

resource "aws_subnet" "public_subent_2" {
  vpc_id            = aws_vpc.ecr_vpc.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "ap-northeast-2c"
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.ecr_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "ap-northeast-2a"
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.ecr_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-2c"
}

resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.ecr_vpc.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.ecr_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw.id
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

