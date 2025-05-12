resource "aws_vpc" "hnc_vpc" {
  cidr_block = "10.16.0.0/20"
  tags = {
    Name = "HnC VPC"
  }
}