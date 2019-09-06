provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./vpc"
  ig_name = var.root_ig_name
  cidr_block = var.root_cidr_block
  private_subnet_cidr_block = var.root_private_subnet_cidr_block
  public_subnet_cidr_block = var.root_public_subnet_cidr_block
  private_subnet_name = var.root_private_subnet_name
  public_subnet_name = var.root_public_subnet_name
}

module "ec2" {
  source = "./ec2"
  ami = var.root_ami
  sg_name = var.root_sg_name
  instance_type = var.root_instance_type
  vpc_id = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_id
}