terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    kubectl = {
      source = "alekc/kubectl"
    }
  }
}


# ---------------------------------------
# Otel Collector
# ---------------------------------------

locals {
  otel_collector_sa_name = "otel-collector-collector"
}

# Namespace
resource "kubernetes_namespace" "observability" {
  metadata {
    name = "observability"
  }
}

# SA
resource "kubernetes_service_account" "otel_collector" {
  metadata {
    name      = local.otel_collector_sa_name
    namespace = "observability"
  }
  automount_service_account_token = true
}

# RBAC
resource "kubectl_manifest" "otel_collector_kubeletstats_rbac" {
  yaml_body = <<EOF
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: otel-collector-kubeletstats
rules:
  - apiGroups: [""]
    resources:
      - nodes
      - nodes/proxy
      - nodes/stats
    verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: otel-collector-kubeletstats
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: otel-collector-kubeletstats
subjects:
  - kind: ServiceAccount
    name: ${local.otel_collector_sa_name}
    namespace: observability
EOF
}


# Collector
resource "kubectl_manifest" "otel_collector" {
  yaml_body = templatefile("${path.module}/collector.yaml", {
    otel_collector_sa_name = local.otel_collector_sa_name,
    tempo_host             = var.tempo_host,
    mimir_host             = var.mimir_host,
    loki_host              = var.loki_host,
    k8s_cluster_name       = var.k8s_cluster_name,
  })
}