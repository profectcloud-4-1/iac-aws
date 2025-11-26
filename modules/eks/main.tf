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

# 참고:
# kube-state-metrics, prometheus-node-exporter는 관리형 애드온이 아니므로
# 일반적으로 Helm 등을 통해 배포합니다. 아래 Helm 배포 리소스로 설치합니다.

# kube-state-metrics (Helm)
resource "helm_release" "kube_state_metrics" {
  provider          = helm.eks
  count             = var.enable_kube_state_metrics ? 1 : 0
  name              = "kube-state-metrics"
  repository        = "https://prometheus-community.github.io/helm-charts"
  chart             = "kube-state-metrics"
  namespace         = "kube-system"
  create_namespace  = false
  dependency_update = true
  wait              = true
  timeout           = 600

  depends_on = [
    aws_eks_cluster.this
  ]
}

# prometheus-node-exporter (Helm)
resource "helm_release" "prometheus_node_exporter" {
  provider          = helm.eks
  count             = var.enable_node_exporter ? 1 : 0
  name              = "prometheus-node-exporter"
  repository        = "https://prometheus-community.github.io/helm-charts"
  chart             = "prometheus-node-exporter"
  namespace         = "kube-system"
  create_namespace  = false
  dependency_update = true
  wait              = true
  timeout           = 600

  depends_on = [
    aws_eks_cluster.this
  ]
}


