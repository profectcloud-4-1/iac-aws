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
      version = "6.20.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Project     = "goormdotcom"
      Environment = terraform.workspace
    }
  }
}

module "common_network" {
  source = "./modules/common-network"
  # vpc_cidr_block = "10.9.0.0/16"
}

module "security" {
  source         = "./modules/security"
  vpc_id         = module.common_network.vpc_id
  name_prefix    = "goorm"
  vpc_cidr_block = module.common_network.vpc_cidr_block
}

### RDS ###
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

### ECR Repository ###
module "ecr_user" {
  source               = "./modules/ecr"
  repository_name      = "goormdotcom/user-service"
  image_tag_mutability = "MUTABLE"
  scan_on_push         = true
}
module "ecr_product" {
  source               = "./modules/ecr"
  repository_name      = "goormdotcom/product-service"
  image_tag_mutability = "MUTABLE"
  scan_on_push         = true
}
module "ecr_order" {
  source               = "./modules/ecr"
  repository_name      = "goormdotcom/order-service"
  image_tag_mutability = "MUTABLE"
  scan_on_push         = true
}
module "ecr_payment" {
  source               = "./modules/ecr"
  repository_name      = "goormdotcom/payment-service"
  image_tag_mutability = "MUTABLE"
  scan_on_push         = true
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
module "vpc_endpoint" {
  source = "./modules/vpc-endpoint"

  name_prefix        = "goorm"
  vpc_id             = module.common_network.vpc_id
  private_subnet_ids = [module.common_network.private_subnet_app_id]
  vpce_sg_id         = module.security.vpce_sg_id
  route_table_ids    = [module.common_network.private_rtb_app_id] # S3 Gateway용
}

### Target Group ###
module "targetgroup_user" {
  source   = "./modules/targetgroup"
  vpc_id   = module.common_network.vpc_id
  services = ["user"]
}
module "targetgroup_product" {
  source   = "./modules/targetgroup"
  vpc_id   = module.common_network.vpc_id
  services = ["product"]
}
module "targetgroup_order" {
  source   = "./modules/targetgroup"
  vpc_id   = module.common_network.vpc_id
  services = ["order"]
}
module "targetgroup_payment" {
  source   = "./modules/targetgroup"
  vpc_id   = module.common_network.vpc_id
  services = ["payment"]
}

### NLB ###
module "nlb" {
  source     = "./modules/nlb"
  subnet_ids = [module.common_network.private_subnet_app_id]
  target_group_arns_map = {
    tg-user-1    = module.targetgroup_user.target_group_arns["tg-user-1"]
    tg-user-2    = module.targetgroup_user.target_group_arns["tg-user-2"]
    tg-product-1 = module.targetgroup_product.target_group_arns["tg-product-1"]
    tg-product-2 = module.targetgroup_product.target_group_arns["tg-product-2"]
    tg-order-1   = module.targetgroup_order.target_group_arns["tg-order-1"]
    tg-order-2   = module.targetgroup_order.target_group_arns["tg-order-2"]
    tg-payment-1 = module.targetgroup_payment.target_group_arns["tg-payment-1"]
    tg-payment-2 = module.targetgroup_payment.target_group_arns["tg-payment-2"]
  }
}


### Cloud Map (ECS 내부통신 네임스페이스) ###
module "cloudmap" {
  source = "./modules/cloudmap"
  vpc_id = module.common_network.vpc_id
}

### ECS Cluster (Fargate 전용, Service Connect 기본 네임스페이스 설정) ###
module "ecs_cluster" {
  source                        = "./modules/ecs"
  cluster_name                  = "goorm-ecs"
  service_connect_namespace_arn = module.cloudmap.namespace_arn

  service_task_configs = {
    user = {
      image          = var.user_image
      cpu            = 256
      memory         = 512
      container_port = 8080
    }
    product = {
      image          = var.product_image
      cpu            = 256
      memory         = 512
      container_port = 8080
    }
    order = {
      image          = var.order_image
      cpu            = 256
      memory         = 512
      container_port = 8080
    }
    payment = {
      image          = var.payment_image
      cpu            = 256
      memory         = 512
      container_port = 8080
    }
  }
}

### API Gateway ###
module "apigateway" {
  source                     = "./modules/apigateway"
  vpc_link_security_group_id = module.security.vpc_link_sg_id
  vpi_link_subnet_ids        = [module.common_network.private_subnet_app_id]
  listener_arns = {
    user_1    = module.nlb.listener_arns["user_1"]
    user_2    = module.nlb.listener_arns["user_2"]
    product_1 = module.nlb.listener_arns["product_1"]
    product_2 = module.nlb.listener_arns["product_2"]
    order_1   = module.nlb.listener_arns["order_1"]
    order_2   = module.nlb.listener_arns["order_2"]
    payment_1 = module.nlb.listener_arns["payment_1"]
    payment_2 = module.nlb.listener_arns["payment_2"]
  }
}


### s3(presigned용)
module "presigned_s3" {
  source      = "./modules/s3"
  bucket_name = var.presigned_bucket_name
  versioning  = true
}

### CloudFront (api.goorm.store -> API Gateway) ###
module "cloudfront" {
  source               = "./modules/cloudfront"
  domain_name          = var.cloudfront_domain_name
  hosted_zone_name     = "goorm.store"
  user_api_endpoint    = module.apigateway.api_endpoints.user
  product_api_endpoint = module.apigateway.api_endpoints.product
  order_api_endpoint   = module.apigateway.api_endpoints.order
  payment_api_endpoint = module.apigateway.api_endpoints.payment
  s3_bucket_name       = module.presigned_s3.bucket_name
}

