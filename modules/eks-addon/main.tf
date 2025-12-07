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

resource "kubernetes_manifest" "coredns_pdb_override" {
  manifest = {
    apiVersion = "policy/v1"
    kind       = "PodDisruptionBudget"
    metadata = {
      name      = "coredns"
      namespace = "kube-system"
    }
    spec = {
      minAvailable = 2
      selector = {
        matchLabels = {
          k8s-app = "kube-dns"
        }
      }
    }
  }

  depends_on = [aws_eks_addon.coredns]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = var.cluster_name
  addon_name   = "kube-proxy"
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name             = var.cluster_name
  addon_name               = "vpc-cni"
  service_account_role_arn = aws_iam_role.vpc_cni.arn

  depends_on = [aws_iam_role_policy_attachment.vpc_cni_policy]
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

# resource "helm_release" "prometheus_node_exporter" {
#   name              = "prometheus-node-exporter"
#   repository        = "https://prometheus-community.github.io/helm-charts"
#   chart             = "prometheus-node-exporter"
#   namespace         = "kube-system"
#   create_namespace  = false
#   dependency_update = true
#   wait              = true
#   timeout           = 600
# }
