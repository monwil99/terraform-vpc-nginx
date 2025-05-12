# Security Group (Allow SSH and HTTP)
resource "aws_security_group" "hnc_public_security_group" {
  vpc_id = var.vpc_id
  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [var.source_ip] # For specific IP only
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTPS traffic from anywhere (if needed)
    description = "Allow HTTPS traffic"
  }
  egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
}


# Security Group for Application Load Balancer
resource "aws_security_group" "hnc_alb_sg" {
  name_prefix = "hnc-alb-sg-"
  vpc_id      = var.vpc_id 

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTPS traffic from anywhere (if needed)
    description = "Allow HTTPS traffic"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-security-group"
  }
}