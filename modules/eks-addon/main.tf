terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

resource "aws_eks_addon" "coredns" {
  cluster_name = var.cluster_name
  addon_name   = "coredns"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = var.cluster_name
  addon_name   = "kube-proxy"
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name             = var.cluster_name
  addon_name               = "vpc-cni"
  service_account_role_arn = var.vpc_cni_role_arn
}

resource "helm_release" "kube_state_metrics" {
  name              = "kube-state-metrics"
  repository        = "https://prometheus-community.github.io/helm-charts"
  chart             = "kube-state-metrics"
  namespace         = "kube-system"
  create_namespace  = false
  dependency_update = true
  wait              = true
  timeout           = 600
}

resource "helm_release" "prometheus_node_exporter" {
  name              = "prometheus-node-exporter"
  repository        = "https://prometheus-community.github.io/helm-charts"
  chart             = "prometheus-node-exporter"
  namespace         = "kube-system"
  create_namespace  = false
  dependency_update = true
  wait              = true
  timeout           = 600
}
