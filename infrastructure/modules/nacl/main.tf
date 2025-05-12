# NACL for Public Subnets
resource "aws_network_acl" "hnc_public_nacl" {

  vpc_id = var.vpc_id
  subnet_ids = [
      var.public_subnet_1_id,
      var.public_subnet_2_id
  ]
  
  # Allow HTTPS inbound traffic from any source
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"  # Allow traffic from any source
    from_port  = 443
    to_port    = 443
  }

    # Allow SSH inbound traffic from a specific source
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.source_ip  # # For specific IP only
    from_port  = 22
    to_port    = 22
  }

    # Allow TCP traffic on ephemeral ports for software updates and downloads
  ingress {
    protocol   = "tcp"
    rule_no    = 300 # Use a different rule number
    action     = "allow"
    cidr_block = "0.0.0.0/0"  # Allow from any source
    from_port  = 1024
    to_port    = 65535
  }

  #  Explicitly deny other inbound traffic (recommended for security)
  ingress {
    protocol   = "-1"    # "-1" means all protocols
    rule_no    = 500      # Higher rule number so it's evaluated after the allow rule
    action     = "deny"
    cidr_block = "0.0.0.0/0"  # Apply to all sources
    from_port  = 0
    to_port    = 0    # Deny all ports
  }

  # Allow all inbound traffic (any protocol, any port, any source)
  egress {
    protocol   = "-1"    # Allow all outbound traffic
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "HnC NACL for Public Subnet"
  }
}

# NACL for Private Subnets
resource "aws_network_acl" "hnc_private_nacl" {
  vpc_id = var.vpc_id
  subnet_ids = [
      var.private_subnet_1_id,
      var.private_subnet_2_id
  ]

  # Allow inbound traffic for VPC communication (internal access)
  ingress {
    protocol   = "-1"    # All protocols
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr_block  # Internal VPC traffic
    from_port  = 0
    to_port    = 0
  }

  # Allow outbound traffic (adjust based on security needs)
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr_block
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "HnC NACL for Private Subnet"
  }
}
