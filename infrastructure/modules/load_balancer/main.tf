# Application Load Balancer
resource "aws_lb" "hnc_alb_public" {
  name               = "hnc-public-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_public_sg_id]
  subnets            = [var.public_subnet_1_id, var.public_subnet_2_id] # 2 public subnets

  enable_deletion_protection = false # Adjust as needed

  tags = {
    Name = "HnC Public Load Balancer"
  }
}

# ALB Target Group for HTTPS
resource "aws_lb_target_group" "hnc_alb_public_tg_https" {
  port     = 443
  protocol = "HTTPS"
  vpc_id   = var.vpc_id # Replace with your VPC ID
  health_check {
    path     = "/" # Or a specific HTTPS health check path like /health
    protocol = "HTTPS"
    matcher  = "200" # Expecting an HTTP 200 OK response over HTTPS
    interval = 30
    timeout  = 5
  }
}

# ALB Target Group for HTTP (if your EC2 instance also serves HTTP directly)
resource "aws_lb_target_group" "hnc_alb_public_tg_http" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id # Replace with your VPC ID
  health_check {
    path     = "/" # Or a specific HTTP health check path like /health
    protocol = "HTTP"
    matcher  = "200" # Expecting an HTTP 200 OK response over HTTP
    interval = 30
    timeout  = 5
  }
}

# Attach EC2 Instance to HTTPS Target Group
resource "aws_lb_target_group_attachment" "hnc_alb_pub_tg_attachment_https" {
  target_group_arn = aws_lb_target_group.hnc_alb_public_tg_https.arn
  target_id        = var.ec2_public_instance_id
  port             = 443 # Assuming your EC2 instance listens for HTTPS on port 443
}

# Attach EC2 Instance to HTTP Target Group (if your EC2 instance also serves HTTP directly)
resource "aws_lb_target_group_attachment" "hnc_alb_pub_tg_attachment_http" {
  target_group_arn = aws_lb_target_group.hnc_alb_public_tg_http.arn
  target_id        = var.ec2_public_instance_id
  port             = 80 # Assuming your EC2 instance listens for HTTP on port 80
}

# ALB Listener (HTTP) - Redirect to HTTPS
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.hnc_alb_public.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# ALB Listener (HTTPS)
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.hnc_alb_public.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08" # Choose an appropriate SSL policy
  certificate_arn   = var.alb_cert # Replace with your ACM certificate ARN

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hnc_alb_public_tg_https.arn
  }
}