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
resource "null_resource" "wait_otel_crd" {
  depends_on = [kubectl_manifest.otel_operator]

  provisioner "local-exec" {
    command = <<EOT
kubectl wait --for=condition=Established crd/opentelemetrycollectors.opentelemetry.io --timeout=5m
EOT
  }
}

# Otel - Controller wait
resource "null_resource" "wait_otel_controller" {
  depends_on = [null_resource.wait_otel_crd]

  provisioner "local-exec" {
    command = <<EOT
kubectl rollout status deploy/opentelemetry-operator-controller-manager -n opentelemetry-operator-system --timeout=10m
EOT
  }
}

# Otel - Webhook wait
resource "null_resource" "wait_otel_webhook" {
  depends_on = [null_resource.wait_otel_controller]

  provisioner "local-exec" {
    command = <<EOT
for i in {1..60}; do
  EP_READY=$(kubectl get endpoints opentelemetry-operator-webhook-service -n opentelemetry-operator-system -o jsonpath='{.subsets[0].addresses[0].ip}' 2>/dev/null || true)
  if [[ -n "$EP_READY" ]]; then
    echo "[ok] webhook endpoint: $EP_READY"
    exit 0
  fi
  sleep 2
done
echo "Webhook endpoint not ready" >&2
exit 1
EOT
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

