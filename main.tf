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

# ### ECR Repository ###
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

module "eks" {
  source          = "./modules/eks"
  cluster_name    = "goorm"
  cluster_version = "1.33"
  subnet_ids      = [module.common_network.private_subnet_app_a_id, module.common_network.private_subnet_app_b_id]
}


# EKS 연결용 데이터 소스 (Helm/Kubernetes 프로바이더)
data "aws_eks_cluster" "eks" {
  depends_on = [module.eks]
  name       = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  depends_on = [module.eks]
  name       = module.eks.cluster_name
}

provider "helm" {
  alias = "eks"
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

provider "kubernetes" {
  alias                  = "eks"
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "kubectl" {
  alias                  = "eks"
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
  load_config_file       = false
  apply_retry_count      = 20
}

module "eks_addon" {
  source                             = "./modules/eks-addon"
  cluster_name                       = "goorm"
  vpc_id                             = module.common_network.vpc_id
  vpc_cni_role_arn                   = module.eks.vpc_cni_role_arn
  alb_controller_role_arn            = module.eks.alb_controller_role_arn
  external_secrets_operator_role_arn = module.eks.external_secrets_operator_role_arn
  providers = {
    helm       = helm.eks
    kubernetes = kubernetes.eks
  }
  depends_on = [module.eks]
}

module "k8s_certmanager" {
  source = "./modules/k8s-certmanager"
  providers = {
    helm       = helm.eks
    kubernetes = kubernetes.eks
  }
  depends_on = [module.eks, module.eks_addon]
}
module "k8s_eso" {
  source = "./modules/k8s-eso"
  providers = {
    helm       = helm.eks
    kubernetes = kubernetes.eks
    kubectl    = kubectl.eks
  }
  external_secrets_operator_role_arn = module.eks.external_secrets_operator_role_arn
  depends_on                         = [module.eks, module.eks_addon]
}

# S3 + Telemetry Backend
module "k8s_telemetry_backend" {
  source = "./modules/k8s-telemetry-backend"
  providers = {
    helm       = helm.eks
    kubernetes = kubernetes.eks
  }
  depends_on      = [module.eks, module.eks_addon, module.k8s_certmanager]
  s3_bucket_loki  = "goormdotcom-loki"
  s3_bucket_tempo = "goormdotcom-tempo"
  s3_bucket_mimir = "goormdotcom-mimir"
  aws_region      = var.aws_region
}

module "k8s_otel_operator" {
  source = "./modules/k8s-otel-operator"
  providers = {
    helm       = helm.eks
    kubernetes = kubernetes.eks
  }
  depends_on = [module.eks, module.eks_addon, module.k8s_certmanager]
}

module "k8s_otel_collector" {
  source = "./modules/k8s-otel-collector"
  providers = {
    kubernetes = kubernetes.eks
    kubectl    = kubectl.eks
  }
  tempo_host       = "tempo-distributor.observability.svc.cluster.local" # 클러스터 내 프로비저닝 완료된 Tempo 서비스 IP
  mimir_host       = "mimir-nginx.observability.svc.cluster.local"       # 클러스터 내 프로비저닝 완료된 Mimir 서비스 IP
  loki_host        = "loki.observability.svc.cluster.local"              # 클러스터 내 프로비저닝 완료된 Loki 서비스 IP
  k8s_cluster_name = module.eks.cluster_name
  depends_on       = [module.eks, module.eks_addon, module.k8s_certmanager, module.k8s_eso, module.k8s_ingress, module.k8s_otel_operator]
}


module "k8s_grafana" {
  source = "./modules/k8s-grafana"
  providers = {
    helm       = helm.eks
    kubernetes = kubernetes.eks
  }
  tempo_host = "tempo-query-frontend.observability.svc.cluster.local" # 클러스터 내 프로비저닝 완료된 Tempo 서비스 IP
  mimir_host = "mimir-nginx.observability.svc.cluster.local"          # 클러스터 내 프로비저닝 완료된 Mimir 서비스 IP
  loki_host  = "loki.observability.svc.cluster.local"                 # 클러스터 내 프로비저닝 완료된 Loki 서비스 IP

  namespace  = "observability"
  tempo_port = 3100
  mimir_port = 80
  loki_port  = 3100
  depends_on = [module.eks, module.eks_addon, module.k8s_certmanager, module.k8s_eso, module.k8s_otel_operator]
}


module "k8s_ingress" {
  source = "./modules/k8s-ingress"
  providers = {
    helm       = helm.eks
    kubernetes = kubernetes.eks
    kubectl    = kubectl.eks
  }
  cluster_name            = module.eks.cluster_name
  vpc_id                  = module.common_network.vpc_id
  alb_controller_role_arn = module.eks.alb_controller_role_arn
  depends_on              = [module.eks, module.eks_addon, module.k8s_grafana]
}

# NOTE: 제~~일 마지막에 실행
# module "k8s_argocd" {
#   source = "./modules/k8s-argocd"
#   providers = {
#     helm       = helm.eks
#     kubernetes = kubernetes.eks
#   }
#   depends_on = [module.eks, module.eks_addon, module.k8s_certmanager, module.k8s_eso, module.k8s_ingress, module.k8s_otel]
# }


# module "vpc_endpoint" {
#   source = "./modules/vpc-endpoint"
#
#   name_prefix        = "goorm"
#   vpc_id             = module.common_network.vpc_id
#   private_subnet_ids = [module.common_network.private_subnet_app_a_id, module.common_network.private_subnet_app_b_id]
#   vpce_sg_id         = module.security.vpce_sg_id
#   route_table_ids    = [module.common_network.private_rtb_app_a_id, module.common_network.private_rtb_app_b_id] # S3 Gateway용
# }

### s3(presigned용)
module "presigned_s3" {
  source      = "./modules/s3"
  bucket_name = var.presigned_bucket_name
  versioning  = true
}

