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
