# Create IAM Role for the Instance
resource "aws_iam_role" "hnc_ec2_role" {
  name = "hnc-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "EC2 IAM Role"
  }
}

# Attach permission for logging and observability 
resource "aws_iam_policy_attachment" "cloudwatch_access" {
  name       = "CloudWatchAgentAttachment"
  roles      = [aws_iam_role.hnc_ec2_role.name]
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Attach AmazonSSMManagedInstanceCore Managed Policy
# This are basic permissions for SSM management of EC2 insrance
resource "aws_iam_policy_attachment" "ssm_access" {
  name       = "SSMPolicyAttachment"
  roles      = [aws_iam_role.hnc_ec2_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
