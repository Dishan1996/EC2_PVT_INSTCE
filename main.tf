provider "aws" {
  region = "eu-central-1"
}

module "vpc" {
  source             = "./modules/vpc"
  cidr_block         = "10.0.0.0/16"
  name               = "magento-vpc"
  public_subnet_cidr = "10.0.1.0/24"
  private_subnet_cidr= "10.0.2.0/24"
}

module "ec2" {
  source         = "./modules/ec2"
  ami_id         = "ami-0ef5cb9155d1d95a7" 
  instance_type  = "t3.micro"
  subnet_id      = module.vpc.private_subnet_id
  name           = "magento-instance"
}
