resource "aws_vpc" "goorm" {
  cidr_block = "10.9.0.0/16"
  tags = {
    Name = "goorm-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.goorm.id
  cidr_block = cidrsubnet(aws_vpc.goorm.cidr_block, 4, 0)
  tags = {
    Name = "goorm-public-subnet"
  }
}

resource "aws_subnet" "private-app" {
  vpc_id = aws_vpc.goorm.id
  cidr_block = cidrsubnet(aws_vpc.goorm.cidr_block, 4, 1)
  tags = {
    Name = "goorm-private-subnet-app"
  }
}

resource "aws_subnet" "private-db" {
  vpc_id = aws_vpc.goorm.id
  cidr_block = cidrsubnet(aws_vpc.goorm.cidr_block, 4, 2)
  tags = {
    Name = "goorm-private-subnet-db"
  }
}