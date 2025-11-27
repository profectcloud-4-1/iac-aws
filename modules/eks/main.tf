############################
# EKS Cluster and Add-ons
############################

locals {
  vpc_cni_sa_role_arn = var.enable_irsa_cni ? aws_iam_role.eks_cni_irsa_role[0].arn : null
}

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  version = var.cluster_version

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  tags = var.tags
}

# Managed add-ons
resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "coredns"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "kube-proxy"
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "vpc-cni"
  # IRSA 역할이 생성된 경우에만 서비스어카운트 역할을 연결
  service_account_role_arn = local.vpc_cni_sa_role_arn
}

# EKS에서 관리형으로 제공되는 metrics-server
resource "aws_eks_addon" "metrics_server" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "metrics-server"
}




