variable "region" {
  type    = string
  default = "us-east-1"
}

variable "scope" {
  type    = string
  default = "energy"
}

variable "stage" {
  type    = string
  default = "uat"
}

variable "application" {
  type    = string
  default = "hnc-practical-exam"
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.16.0.0/20"
}

variable "public_subnet_1_cidr_block" {
  type    = string
  default = "10.16.0.0/24"
}

variable "public_subnet_2_cidr_block" {
  type    = string
  default = "10.16.1.0/24"
}

variable "private_subnet_1_cidr_block" {
  type    = string
  default = "10.16.2.0/24"
}

variable "private_subnet_2_cidr_block" {
  type    = string
  default = "10.16.3.0/24"
}

variable "ec2_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ec2_ami" {
  type    = string
  default = "ami-00c1e19c6845d02f0"
}

variable "availability_zone_1" {
  type    = string
  default = "us-east-1a"
}

variable "availability_zone_2" {
  type    = string
  default = "us-east-1b"
}

variable "source_ip" {
  type    = string
  default = "112.201.15.100/32"  # REPLACE with the specific IP for SSH
}

variable "alb_cert" {
  type    = string
  default = "some_cert"  # REPLACE with the specific IP for SSH
}

