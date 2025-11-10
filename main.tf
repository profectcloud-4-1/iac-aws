terraform {
  cloud {
    organization = "goormdotcom"
    hostname     = "app.terraform.io"
    workspaces {
      name = "prod"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "common_network" {
  source = "./modules/common-network"
}

module "security" {
  source         = "./modules/security"
  vpc_id         = module.common_network.vpc_id
  name_prefix    = "goorm"
  vpc_cidr_block = module.common_network.vpc_cidr_block
}

module "rds_user" {
  source                = "./modules/rds"
  name                  = "user"
  db_name               = "goormdotcom"
  vpc_id                = module.common_network.vpc_id
  subnet_ids            = [module.common_network.private_subnet_db_id, module.common_network.private_subnet_db_2_id]
  availability_zone     = "ap-northeast-2a" # 실제 인스턴스는 private-db(2a)에 배치
  instance_class        = "db.t3.micro"
  username              = var.db_master_username
  password              = var.db_master_password
  multi_az              = false
  create_security_group = false
  security_group_ids    = [module.security.rds_user_sg_id]
}

module "rds_product" {
  source                = "./modules/rds"
  name                  = "product"
  db_name               = "goormdotcom"
  vpc_id                = module.common_network.vpc_id
  subnet_ids            = [module.common_network.private_subnet_db_id, module.common_network.private_subnet_db_2_id]
  availability_zone     = "ap-northeast-2a"
  instance_class        = "db.t3.micro"
  username              = var.db_master_username
  password              = var.db_master_password
  multi_az              = false
  create_security_group = false
  security_group_ids    = [module.security.rds_product_sg_id]
}

module "rds_order" {
  source                = "./modules/rds"
  name                  = "order"
  db_name               = "goormdotcom"
  vpc_id                = module.common_network.vpc_id
  subnet_ids            = [module.common_network.private_subnet_db_id, module.common_network.private_subnet_db_2_id]
  availability_zone     = "ap-northeast-2a"
  instance_class        = "db.t3.micro"
  username              = var.db_master_username
  password              = var.db_master_password
  multi_az              = false
  create_security_group = false
  security_group_ids    = [module.security.rds_order_sg_id]
}

module "rds_payment" {
  source                = "./modules/rds"
  name                  = "payment"
  db_name               = "goormdotcom"
  vpc_id                = module.common_network.vpc_id
  subnet_ids            = [module.common_network.private_subnet_db_id, module.common_network.private_subnet_db_2_id]
  availability_zone     = "ap-northeast-2a"
  instance_class        = "db.t3.micro"
  username              = var.db_master_username
  password              = var.db_master_password
  multi_az              = false
  create_security_group = false
  security_group_ids    = [module.security.rds_payment_sg_id]
}

output "common_network" {
  value = module.common_network.vpc_id
}

output "common_network_public_subnet_id" {
  value = module.common_network.public_subnet_id
}

output "common_network_private_subnet_app_id" {
  value = module.common_network.private_subnet_app_id
}

output "common_network_private_subnet_db_id" {
  value = module.common_network.private_subnet_db_id
}

output "rds_user_endpoint" {
  value = module.rds_user.endpoint
}

output "rds_product_endpoint" {
  value = module.rds_product.endpoint
}

output "rds_order_endpoint" {
  value = module.rds_order.endpoint
}

output "rds_payment_endpoint" {
  value = module.rds_payment.endpoint
}

module "vpc_endpoint" {
  source = "./modules/vpc-endpoint"

  name_prefix = "goorm"
  vpc_id             = module.common_network.vpc_id
  private_subnet_ids = [module.common_network.private_subnet_app_id]
  vpce_sg_id         = module.security.vpce_sg_id
  route_table_ids    = [module.vpc_endpoint.route_table_id]  # Gateway용
}