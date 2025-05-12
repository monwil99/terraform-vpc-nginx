# Public Subnet 1
resource "aws_subnet" "hnc_public_subnet_1" {
  vpc_id            = var.vpc_id
  cidr_block        = var.public_subnet_1_cidr_block
  availability_zone = var.availability_zone_1

  tags = {
    Name = "HnC Public Subnet 1"
  }
}

# Public Subnet 2
resource "aws_subnet" "hnc_public_subnet_2" {
  vpc_id            = var.vpc_id
  cidr_block        = var.public_subnet_2_cidr_block
  availability_zone = var.availability_zone_2

  tags = {
    Name = "HnC Public Subnet 2"
  }
}

# Private Subnet 1
resource "aws_subnet" "hnc_private_subnet_1" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet_1_cidr_block
  availability_zone = var.availability_zone_1

  tags = {
    Name = "HnC Private Subnet 1"
  }
}

# Private Subnet 1
resource "aws_subnet" "hnc_private_subnet_2" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet_2_cidr_block
  availability_zone = var.availability_zone_2

  tags = {
    Name = "HnC Private Subnet 2"
  }
}