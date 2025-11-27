terraform {
  cloud {
    organization = "goormdotcom"
    hostname     = "app.terraform.io"
    workspaces {
      name = "staging"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.20.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.33"
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

# ### RDS ###
# module "rds_user" {
#   source                = "./modules/rds"
#   name                  = "user"
#   db_name               = "goormdotcom"
#   vpc_id                = module.common_network.vpc_id
#   subnet_ids            = [module.common_network.private_subnet_db_id, module.common_network.private_subnet_db_2_id]
#   availability_zone     = "ap-northeast-2a" # 실제 인스턴스는 private-db(2a)에 배치
#   instance_class        = "db.t3.micro"
#   username              = var.db_master_username
#   password              = var.db_master_password
#   multi_az              = false
#   create_security_group = false
#   security_group_ids    = [module.security.rds_user_sg_id]
# }
# module "rds_product" {
#   source                = "./modules/rds"
#   name                  = "product"
#   db_name               = "goormdotcom"
#   vpc_id                = module.common_network.vpc_id
#   subnet_ids            = [module.common_network.private_subnet_db_id, module.common_network.private_subnet_db_2_id]
#   availability_zone     = "ap-northeast-2a"
#   instance_class        = "db.t3.micro"
#   username              = var.db_master_username
#   password              = var.db_master_password
#   multi_az              = false
#   create_security_group = false
#   security_group_ids    = [module.security.rds_product_sg_id]
# }
# module "rds_order" {
#   source                = "./modules/rds"
#   name                  = "order"
#   db_name               = "goormdotcom"
#   vpc_id                = module.common_network.vpc_id
#   subnet_ids            = [module.common_network.private_subnet_db_id, module.common_network.private_subnet_db_2_id]
#   availability_zone     = "ap-northeast-2a"
#   instance_class        = "db.t3.micro"
#   username              = var.db_master_username
#   password              = var.db_master_password
#   multi_az              = false
#   create_security_group = false
#   security_group_ids    = [module.security.rds_order_sg_id]
# }
# module "rds_payment" {
#   source                = "./modules/rds"
#   name                  = "payment"
#   db_name               = "goormdotcom"
#   vpc_id                = module.common_network.vpc_id
#   subnet_ids            = [module.common_network.private_subnet_db_id, module.common_network.private_subnet_db_2_id]
#   availability_zone     = "ap-northeast-2a"
#   instance_class        = "db.t3.micro"
#   username              = var.db_master_username
#   password              = var.db_master_password
#   multi_az              = false
#   create_security_group = false
#   security_group_ids    = [module.security.rds_payment_sg_id]
# }

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

module "eks" {
  source          = "./modules/eks"
  cluster_name    = "goorm"
  cluster_version = "1.33"
  subnet_ids      = [module.common_network.private_subnet_app_a_id, module.common_network.private_subnet_app_b_id]
  enable_irsa_cni = true
}


# EKS 연결용 데이터 소스 (Helm/Kubernetes 프로바이더)
# data "aws_eks_cluster" "eks" {
#   depends_on = [module.eks]
#   name       = module.eks.cluster_name
# }
# data "aws_eks_cluster_auth" "eks" {
#   depends_on = [module.eks]
#   name       = module.eks.cluster_name
# }

# provider "kubernetes" {
#   alias                  = "eks"
#   host                   = data.aws_eks_cluster.eks.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.eks.token
# }

# provider "helm" {
#   alias = "eks"
#   kubernetes {
#     host                   = data.aws_eks_cluster.eks.endpoint
#     cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
#     token                  = data.aws_eks_cluster_auth.eks.token
#   }
# }

# module "helm" {
#   source                    = "./modules/helm"
#   enable_kube_state_metrics = true
#   enable_node_exporter      = true
#   providers = {
#     helm       = helm.eks
#     kubernetes = kubernetes.eks
#   }
# }

module "vpc_endpoint" {
  source = "./modules/vpc-endpoint"

  name_prefix        = "goorm"
  vpc_id             = module.common_network.vpc_id
  private_subnet_ids = [module.common_network.private_subnet_app_a_id, module.common_network.private_subnet_app_b_id]
  vpce_sg_id         = module.security.vpce_sg_id
  route_table_ids    = [module.common_network.private_rtb_app_a_id, module.common_network.private_rtb_app_b_id] # S3 Gateway용
}

### API Gateway ###
module "apigateway" {
  count = var.enable_apigateway ? 1 : 0

  source                     = "./modules/apigateway"
  vpc_link_security_group_id = module.security.vpc_link_sg_id
  vpi_link_subnet_ids        = [module.common_network.private_subnet_app_a_id, module.common_network.private_subnet_app_b_id]
}


### s3(presigned용)
module "presigned_s3" {
  source      = "./modules/s3"
  bucket_name = var.presigned_bucket_name
  versioning  = true
}

