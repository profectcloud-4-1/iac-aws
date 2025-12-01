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

# ---------------------------------------
# ServiceAccount for AWS Load Balancer Controller (IRSA)
# ---------------------------------------
resource "kubernetes_service_account" "alb_controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = var.alb_controller_role_arn
    }
    labels = {
      "app.kubernetes.io/name"      = "aws-load-balancer-controller"
      "app.kubernetes.io/component" = "controller"
    }
  }
}

# ---------------------------------------
# AWS Load Balancer Controller (Helm) - use precreated SA
# ---------------------------------------
resource "helm_release" "aws_load_balancer_controller" {
  name              = "aws-load-balancer-controller"
  repository        = "https://aws.github.io/eks-charts"
  chart             = "aws-load-balancer-controller"
  namespace         = "kube-system"
  create_namespace  = false
  dependency_update = true
  wait              = true
  timeout           = 120
  atomic            = true

  values = [
    yamlencode({
      clusterName = var.cluster_name
      region      = "ap-northeast-2"
      vpcId       = var.vpc_id
      serviceAccount = {
        create = false
        name   = kubernetes_service_account.alb_controller.metadata[0].name
      }
    })
  ]

  depends_on = [kubernetes_service_account.alb_controller]
}

# ---------------------------------------
# External Secrets Operator (Helm) - use precreated SA
# ---------------------------------------
resource "kubernetes_namespace" "external_secrets" {
  metadata {
    name = "external-secrets"
  }
}

resource "kubernetes_service_account" "external_secrets_operator" {
  metadata {
    name      = "external-secrets-operator"
    namespace = "external-secrets"
    annotations = {
      "eks.amazonaws.com/role-arn" = var.external_secrets_operator_role_arn
    }
  }
}

resource "helm_release" "external_secrets_operator" {
  name              = "external-secrets-operator"
  repository        = "https://charts.external-secrets.io"
  chart             = "external-secrets"
  namespace         = "external-secrets"
  create_namespace  = false
  dependency_update = true
  wait              = true
  timeout           = 120
  atomic            = true

  values = [
    yamlencode({
      serviceAccount = {
        create = false
        name   = kubernetes_service_account.external_secrets_operator.metadata[0].name
      }
    })
  ]

  depends_on = [
    kubernetes_namespace.external_secrets,
    kubernetes_service_account.external_secrets_operator
  ]
}

# # ---------------------------------------
# # ArgoCD (Helm)
# # ---------------------------------------
# resource "helm_release" "argocd" {
#   name              = "argocd"
#   repository        = "https://argoproj.github.io/argo-helm"
#   chart             = "argo-cd"
#   namespace         = "argocd"
#   create_namespace  = false
#   dependency_update = true
#   wait              = true
#   timeout           = 600
# }

# # ArgoCD Application (TODO: 작성중)
# resource "kubernetes_manifest" "bootstrap_application" {
#   manifest = {
#     apiVersion = "argoproj.io/v1alpha1"
#     kind       = "Application"
#     metadata = {
#       name      = "bootstrap"
#       namespace = "argocd"
#     }
#     spec = {
#       project = "default"
#       source = {
#         repoURL = "https://github.com/argoproj/argo-cd.git"
#         path = "manifests/crds"
#         targetRevision = "HEAD"
#       }
#     }
#   }
# }