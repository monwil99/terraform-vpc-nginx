# Key Pair
resource "aws_key_pair" "hnc_public_ec2_key_pair" {
  key_name   = "my-key-pair"
  public_key = file("${path.module}/../../id_rsa.pub")
  
  tags = {
    Name = "HnC Public EC2 Key Pair"
  }
}

# IAM EC2Instance Profile
resource "aws_iam_instance_profile" "hnc_ec2_profile" {
  name = "hnc-ec2-profile"
  role = var.ec2_role_name
}

# EC2 Instance in Public Subnet
resource "aws_instance" "hnc_public_ec2" {
  ami             = var.ec2_ami
  instance_type   = var.ec2_instance_type
  subnet_id       = var.public_subnet_id
  vpc_security_group_ids = [var.vpc_security_group_id]

  key_name        = aws_key_pair.hnc_public_ec2_key_pair.key_name
  iam_instance_profile = aws_iam_instance_profile.hnc_ec2_profile.name
  associate_public_ip_address = true # Assign public IP

  # Sandbox limitation where a policy is preventing my cloud user from performing the ec2:RunInstances on the declared EBS encrypted volume
  # ebs_block_device {
  #   device_name           = "/dev/sda1" # Or the device name of your root volume
  #   encrypted             = true
  #   delete_on_termination = true    # Optional: Delete the volume when the instance is terminated
  # }

  # Install Python 3 to align with Ansible version
  user_data = <<-EOF

    #!/bin/bash

    yum update -y
    yum groupinstall -y "Development Tools"
    yum install -y gcc openssl-devel bzip2-devel libffi-devel
    cd /usr/src
    wget https://www.python.org/ftp/python/3.12.2/Python-3.12.2.tgz
    tar xzf Python-3.12.2.tgz
    cd Python-3.12.2
    ./configure --enable-optimizations
    make altinstall

  EOF

  tags = {
      Name = "HnC Practicals Public EC2"
  }
}