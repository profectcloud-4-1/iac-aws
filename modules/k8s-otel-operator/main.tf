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

# NOTE: Before: 저렇게 가져온 응답내용 보면 여러 리소스가 한파일에 들어있음. 이 구조의 yaml파일이 제대로 처리 안돼서 리소스 생성이 안되고있어서 변경함.
# data "http" "otel_operator" {
#   url = "https://github.com/open-telemetry/opentelemetry-operator/releases/latest/download/opentelemetry-operator.yaml"
# }

# resource "kubectl_manifest" "otel_operator" {
#   yaml_body = data.http.otel_operator.response_body
# }

data "http" "otel_operator" {
  url = "https://github.com/open-telemetry/opentelemetry-operator/releases/latest/download/opentelemetry-operator.yaml"
}

locals {
  raw_yaml  = data.http.otel_operator.response_body
  documents = split("\n---", local.raw_yaml)
}

resource "kubectl_manifest" "otel_operator" {
  for_each = {
    for i, doc in local.documents :
    i => doc
    if trimspace(doc) != ""
  }

  yaml_body = each.value
}