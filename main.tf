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
    kubectl = {
      source = "alekc/kubectl"
    }
  }
}

locals {
  tf_log_level = "DEBUG"
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
  subnet_ids            = [module.common_network.private_subnet_db_a_id, module.common_network.private_subnet_db_b_id]
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
  subnet_ids            = [module.common_network.private_subnet_db_a_id, module.common_network.private_subnet_db_b_id]
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
  subnet_ids            = [module.common_network.private_subnet_db_a_id, module.common_network.private_subnet_db_b_id]
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
  subnet_ids            = [module.common_network.private_subnet_db_a_id, module.common_network.private_subnet_db_b_id]
  availability_zone     = "ap-northeast-2a"
  instance_class        = "db.t3.micro"
  username              = var.db_master_username
  password              = var.db_master_password
  multi_az              = false
  create_security_group = false
  security_group_ids    = [module.security.rds_payment_sg_id]
}

# ### ECR Repository ###
# NOTE: ECR 돈도 딱히 안나가고, 내릴때마다 이미지 지워지니까 프로비저닝 대상에서 제외했습니다.
# module "ecr_user" {
#   source               = "./modules/ecr"
#   repository_name      = "goormdotcom/user-service"
#   image_tag_mutability = "MUTABLE"
#   scan_on_push         = true
# }
# module "ecr_product" {
#   source               = "./modules/ecr"
#   repository_name      = "goormdotcom/product-service"
#   image_tag_mutability = "MUTABLE"
#   scan_on_push         = true
# }
# module "ecr_order" {
#   source               = "./modules/ecr"
#   repository_name      = "goormdotcom/order-service"
#   image_tag_mutability = "MUTABLE"
#   scan_on_push         = true
# }
# module "ecr_payment" {
#   source               = "./modules/ecr"
#   repository_name      = "goormdotcom/payment-service"
#   image_tag_mutability = "MUTABLE"
#   scan_on_push         = true
# }
# module "ecr_auth" {
#   source               = "./modules/ecr"
#   repository_name      = "goormdotcom/auth-service"
#   image_tag_mutability = "MUTABLE"
#   scan_on_push         = true
# }

# ### ECR Policy. 한 정책의 Resource에 여러 ECR 레포지토리 포함 ###
# module "ecr_policy_user" {
#   source = "./modules/ecr-policy"
#   repository_arns = [
#     module.ecr_user.repository_arn,
#     module.ecr_auth.repository_arn,
#     module.ecr_product.repository_arn,
#     module.ecr_order.repository_arn,
#     module.ecr_payment.repository_arn
#   ]
# }

# ------- EKS -------
module "eks" {
  source          = "./modules/eks"
  cluster_name    = "goorm"
  cluster_version = "1.33"
  subnet_ids      = [module.common_network.private_subnet_app_a_id, module.common_network.private_subnet_app_b_id]
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name
}

provider "helm" {
  alias = "eks"
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

provider "kubernetes" {
  alias                  = "eks"
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "kubectl" {
  alias                  = "eks"
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.eks.token
  load_config_file       = false
  apply_retry_count      = 20
}

module "eks_addon" {
  source       = "./modules/eks-addon"
  cluster_name = "goorm"
  providers = {
    helm       = helm.eks
    kubernetes = kubernetes.eks
  }
  depends_on = [module.eks, module.k8s_iam_role]
}

module "eks_nodepool" {
  source       = "./modules/eks-nodepool"
  depends_on   = [module.eks, module.eks_addon]
}

module "k8s_iam_role" {
  source            = "./modules/k8s-iam-role"
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_issuer_url   = module.eks.oidc_issuer_url
  depends_on        = [module.eks]
}

module "k8s_certmanager" {
  source = "./modules/k8s-certmanager"
  providers = {
    helm       = helm.eks
    kubernetes = kubernetes.eks
  }
  depends_on = [module.eks, module.eks_addon]
}

# Loki, Tempo, Mimir가 데이터를 저장할 S3 Buckets + IRSA
module "telemetry_s3" {
  source            = "./modules/telemetry-s3"
  aws_region        = var.aws_region
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_issuer_url   = module.eks.oidc_issuer_url
  depends_on        = [module.eks]
}

### s3(presigned용)
module "presigned_s3" {
  source      = "./modules/s3"
  bucket_name = var.presigned_bucket_name
  versioning  = true
}

# MSK
module "msk" {
  source             = "./modules/msk"
  subnet_ids         = [module.common_network.private_subnet_msk_a_id, module.common_network.private_subnet_msk_b_id, module.common_network.private_subnet_msk_c_id]
  vpc_id             = module.common_network.vpc_id
  vpc_cidr_block     = module.common_network.vpc_cidr_block
  security_group_ids = [module.security.msk_sg_id]
}

# TODO: SecretsManager Update (RDS Credentials, MSK Credentials)

