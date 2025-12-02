terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    kubectl = {
      source = "alekc/kubectl"
    }
    null = {
      source = "hashicorp/null"
    }
    http = {
      source = "hashicorp/http"
    }
  }
}


# ---------------------------------------
# Otel Operator
# ---------------------------------------
data "http" "otel_operator" {
  url = "https://github.com/open-telemetry/opentelemetry-operator/releases/latest/download/opentelemetry-operator.yaml"
}

resource "kubectl_manifest" "otel_operator" {
  yaml_body = data.http.otel_operator.response_body
}

# Otel - CRD wait



# ---------------------------------------
# Otel Collector
# ---------------------------------------

locals {
  otel_collector_sa_name = "otel-collector-collector"
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

