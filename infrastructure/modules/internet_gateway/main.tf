# Internet Gateway
resource "aws_internet_gateway" "hnc_igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "HnC Internet Gateway"
  }
}