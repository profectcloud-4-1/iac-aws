############################
# EKS IAM Roles and Policies
############################

locals {
  # IRSA 신뢰정책 Condition 키에 쓰기 위해 https:// 접두어 제거
  oidc_provider_hostpath = var.oidc_provider_url == null ? null : replace(var.oidc_provider_url, "https://", "")
}

########################
# Cluster Role (Control Plane)
########################
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-cluster-role"
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_role_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_role_vpc_resource_controller" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

########################
# Node Role (Managed Node Group / EC2)
########################
resource "aws_iam_role" "eks_node_role" {
  name = "${var.cluster_name}-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-node-role"
  })
}

resource "aws_iam_role_policy_attachment" "eks_node_role_worker_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_node_role_ecr_readonly" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# 베스트 프랙티스: CNI 권한은 IRSA(aws-node 서비스어카운트)에 부여하고
# 노드 역할에는 부여하지 않는 구성을 기본값으로 채택
# 필요 시 아래를 활성화할 수 있도록 주석만 남김
# resource "aws_iam_role_policy_attachment" "eks_node_role_cni_policy" {
#   role       = aws_iam_role.eks_node_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
# }

########################
# VPC CNI Addon IRSA Role (aws-node)
########################
resource "aws_iam_role" "eks_cni_irsa_role" {
  count = var.enable_irsa_cni ? 1 : 0

  name = "${var.cluster_name}-cni-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = var.oidc_provider_arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${local.oidc_provider_hostpath}:aud" = "sts.amazonaws.com",
            "${local.oidc_provider_hostpath}:sub" = "system:serviceaccount:kube-system:aws-node"
          }
        }
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-cni-irsa-role"
  })
}

resource "aws_iam_role_policy_attachment" "eks_cni_irsa_policy" {
  count = var.enable_irsa_cni ? 1 : 0

  role       = aws_iam_role.eks_cni_irsa_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}


