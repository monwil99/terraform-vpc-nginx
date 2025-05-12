// required to discover the current account id
data "aws_caller_identity" "current" {
}

module "vpc" {
  source  = "./modules/vpc"
  vpc_cidr_block = var.vpc_cidr_block
}

module "subnet" {
  source  = "./modules/subnet"
  vpc_id = module.vpc.vpc_id
  public_subnet_1_cidr_block = var.public_subnet_1_cidr_block
  public_subnet_2_cidr_block = var.public_subnet_2_cidr_block
  private_subnet_1_cidr_block = var.private_subnet_1_cidr_block
  private_subnet_2_cidr_block = var.private_subnet_2_cidr_block
  availability_zone_1 = var.availability_zone_1
  availability_zone_2 = var.availability_zone_2
}

module "nacl" {
  source = "./modules/nacl"
  vpc_id = module.vpc.vpc_id
  vpc_cidr_block = var.vpc_cidr_block
  public_subnet_1_id = module.subnet.public_subnet_1_id
  public_subnet_2_id = module.subnet.public_subnet_2_id
  private_subnet_1_id = module.subnet.private_subnet_1_id
  private_subnet_2_id = module.subnet.private_subnet_2_id
  source_ip = var.source_ip
}

module "internet_gateway" {
  source = "./modules/internet_gateway"
  vpc_id = module.vpc.vpc_id
}

module "route_table" {
  source = "./modules/route_table"
  vpc_id = module.vpc.vpc_id
  internet_gateway_id = module.internet_gateway.internet_gateway_id
  public_subnet_1_id = module.subnet.public_subnet_1_id
  public_subnet_2_id = module.subnet.public_subnet_2_id
  private_subnet_1_id = module.subnet.private_subnet_1_id
  private_subnet_2_id = module.subnet.private_subnet_2_id
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
  source_ip = var.source_ip
}

module "iam_role" {
  source = "./modules/iam_role"
}

module "ec2" {
  source = "./modules/ec2"
  vpc_security_group_id = module.security_group.security_group_public_id
  ec2_ami = var.ec2_ami
  ec2_instance_type = var.ec2_instance_type
  public_subnet_id = module.subnet.public_subnet_1_id
  ec2_role_name = module.iam_role.iam_role_ec2_public
}

# Placeholder code when a trusted certificate is available that can be attached to an ALB

# module "load_balancer" {
#   source = "./modules/load_balancer"
#   vpc_id = module.vpc.vpc_id
#   public_subnet_1_id = module.subnet.public_subnet_1_id
#   public_subnet_2_id = module.subnet.public_subnet_2_id
#   ec2_public_instance_id = module.ec2.ec2_instance_public_id
#   alb_public_sg_id = module.security_group.security_group_alb_public_id
#   alb_cert = var.alb_cert
# }

# module "waf" {
#   source = "./modules/waf"
#   source_ip = var.source_ip
#   public_alb_arn = module.load_balancer.public_alb_arn
# }
