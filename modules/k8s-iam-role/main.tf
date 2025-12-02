terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# ---------------------------------------
# EKS IAM VPC CNI Role
# ---------------------------------------
resource "aws_iam_role" "vpc_cni" {
  name = "eks-vpc-cni-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "vpc_cni_policy" {
  role       = aws_iam_role.vpc_cni.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# ---------------------------------------
# EKS ALB Controller IRSA Role
# ---------------------------------------

resource "aws_iam_policy" "alb_controller" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "IAM policy for AWS Load Balancer Controller (customer managed)"
  policy      = file("${path.module}/alb-controller-policy.json")
}

resource "aws_iam_role" "alb_controller" {
  name = "eks-alb-controller-irsa"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = var.oidc_provider_arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${replace(var.oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller",
          "${replace(var.oidc_issuer_url, "https://", "")}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "alb_controller_attach" {
  role       = aws_iam_role.alb_controller.name
  policy_arn = aws_iam_policy.alb_controller.arn
}

# ---------------------------------------
# IRSA Roles for External Secrets Operator
# ---------------------------------------
resource "aws_iam_role" "external_secrets_operator" {
  name = "eks-external-secrets-operator-irsa"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "external_secrets_operator_policy" {
  role       = aws_iam_role.external_secrets_operator.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}


# ---------------------------------------
# IRSA Roles for Observability (Loki/Tempo/Mimir) - S3 access
# ---------------------------------------

# resource "aws_iam_role" "loki_s3" {
#   name = "eks-irsa-loki-s3"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Effect = "Allow",
#       Principal = {
#         Federated = var.oidc_provider_arn
#       },
#       Action = "sts:AssumeRoleWithWebIdentity",
#       Condition = {
#         StringEquals = {
#           "${replace(var.oidc_issuer_url, "https://", "")}:aud" = "sts.amazonaws.com",
#           "${replace(var.oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:observability:loki"
#         }
#       }
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "loki_s3" {
#   role       = aws_iam_role.loki_s3.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
# }

# resource "aws_iam_role" "tempo_s3" {
#   name = "eks-irsa-tempo-s3"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Effect = "Allow",
#       Principal = {
#         Federated = var.oidc_provider_arn
#       },
#       Action = "sts:AssumeRoleWithWebIdentity",
#       Condition = {
#         StringEquals = {
#           "${replace(var.oidc_issuer_url, "https://", "")}:aud" = "sts.amazonaws.com",
#           "${replace(var.oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:observability:tempo"
#         }
#       }
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "tempo_s3" {
#   role       = aws_iam_role.tempo_s3.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
# }

# resource "aws_iam_role" "mimir_s3" {
#   name = "eks-irsa-mimir-s3"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Effect = "Allow",
#       Principal = {
#         Federated = var.oidc_provider_arn
#       },
#       Action = "sts:AssumeRoleWithWebIdentity",
#       Condition = {
#         StringEquals = {
#           "${replace(var.oidc_issuer_url, "https://", "")}:aud" = "sts.amazonaws.com",
#           "${replace(var.oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:observability:mimir"
#         }
#       }
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "mimir_s3" {
#   role       = aws_iam_role.mimir_s3.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
# }