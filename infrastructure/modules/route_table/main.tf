# Route Table for Public Subnet
resource "aws_route_table" "hnc_public_route_table" {
  vpc_id = var.vpc_id
  tags = {
    Name = "HnC Public Route Table"
  }
}

# Route Table for Private Subnet
resource "aws_route_table" "hnc_private_route_table" {
  vpc_id = var.vpc_id

  # This automatically create a local routing with destination VPCs CIDR range

  tags = {
    Name = "HnC Private Route Table"
  }
}

# Route to Internet Gateway
resource "aws_route" "hnc_route_internet_access" {
  route_table_id         = aws_route_table.hnc_public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id
}

# Route Table Association with Public Subnet 1
resource "aws_route_table_association" "hnc_public_subnet_association_1" {
  subnet_id      = var.public_subnet_1_id
  route_table_id = aws_route_table.hnc_public_route_table.id
}

# Route Table Association with Public Subnet 2
resource "aws_route_table_association" "hnc_public_subnet_association_2" {
  subnet_id      = var.public_subnet_2_id
  route_table_id = aws_route_table.hnc_public_route_table.id
}

# Route Table Association with Private Subnet 1
resource "aws_route_table_association" "hnc_private_subnet_association_1" {
  subnet_id      = var.private_subnet_1_id
  route_table_id = aws_route_table.hnc_private_route_table.id
}

# Route Table Association with Private Subnet 2
resource "aws_route_table_association" "hnc_private_subnet_association_2" {
  subnet_id      = var.private_subnet_2_id
  route_table_id = aws_route_table.hnc_private_route_table.id
}