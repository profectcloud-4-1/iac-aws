terraform {
    cloud {
      organization = "goormdotcom"
      hostname = "app.terraform.io"
      workspaces {
        name = "prod"
      }
    }

    required_providers {
      aws = {
        source = "hashicorp/aws"
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
  source      = "./modules/security"
  vpc_id      = module.common_network.vpc_id
  name_prefix = "goorm"
  vpc_cidr_block = module.common_network.vpc_cidr_block
}

### RDS ###
module "rds_user" {
  source                         = "./modules/rds"
  name                           = "user"
  db_name                        = "goormdotcom"
  vpc_id                         = module.common_network.vpc_id
  subnet_ids                     = [module.common_network.private_subnet_db_id, module.common_network.private_subnet_db_2_id]
  availability_zone              = "ap-northeast-2a" # 실제 인스턴스는 private-db(2a)에 배치
  instance_class                 = "db.t3.micro"
  username                       = var.db_master_username
  password                       = var.db_master_password
  multi_az                       = false
  create_security_group          = false
  security_group_ids             = [module.security.rds_user_sg_id]
}
module "rds_product" {
  source                         = "./modules/rds"
  name                           = "product"
  db_name                        = "goormdotcom"
  vpc_id                         = module.common_network.vpc_id
  subnet_ids                     = [module.common_network.private_subnet_db_id, module.common_network.private_subnet_db_2_id]
  availability_zone              = "ap-northeast-2a"
  instance_class                 = "db.t3.micro"
  username                       = var.db_master_username
  password                       = var.db_master_password
  multi_az                       = false
  create_security_group          = false
  security_group_ids             = [module.security.rds_product_sg_id]
}
module "rds_order" {
  source                         = "./modules/rds"
  name                           = "order"
  db_name                        = "goormdotcom"
  vpc_id                         = module.common_network.vpc_id
  subnet_ids                     = [module.common_network.private_subnet_db_id, module.common_network.private_subnet_db_2_id]
  availability_zone              = "ap-northeast-2a"
  instance_class                 = "db.t3.micro"
  username                       = var.db_master_username
  password                       = var.db_master_password
  multi_az                       = false
  create_security_group          = false
  security_group_ids             = [module.security.rds_order_sg_id]
}
module "rds_payment" {
  source                         = "./modules/rds"
  name                           = "payment"
  db_name                        = "goormdotcom"
  vpc_id                         = module.common_network.vpc_id
  subnet_ids                     = [module.common_network.private_subnet_db_id, module.common_network.private_subnet_db_2_id]
  availability_zone              = "ap-northeast-2a"
  instance_class                 = "db.t3.micro"
  username                       = var.db_master_username
  password                       = var.db_master_password
  multi_az                       = false
  create_security_group          = false
  security_group_ids             = [module.security.rds_payment_sg_id]
}

### ECR Repository ###
module "ecr_user" {
  source = "./modules/ecr"
  repository_name = "goormdotcom/user-service"
  image_tag_mutability = "MUTABLE"
  scan_on_push = true
}
module "ecr_product" {
  source = "./modules/ecr"
  repository_name = "goormdotcom/product-service"
  image_tag_mutability = "MUTABLE"
  scan_on_push = true
}
module "ecr_order" {
  source = "./modules/ecr"
  repository_name = "goormdotcom/order-service"
  image_tag_mutability = "MUTABLE"
  scan_on_push = true
}
module "ecr_payment" {
  source = "./modules/ecr"
  repository_name = "goormdotcom/payment-service"
  image_tag_mutability = "MUTABLE"
  scan_on_push = true
}

### ECR Policy. 한 정책의 Resource에 여러 ECR 레포지토리 포함 ###
module "ecr_policy_user" {
  source = "./modules/ecr-policy"
  repository_arns = [
    module.ecr_user.repository_arn,
    module.ecr_product.repository_arn,
    module.ecr_order.repository_arn,
    module.ecr_payment.repository_arn
  ]
}