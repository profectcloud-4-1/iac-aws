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

resource "helm_release" "otel_operator" {
  name              = "opentelemetry-operator"
  repository        = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart             = "opentelemetry-operator"
  namespace         = "opentelemetry-operator-system"
  create_namespace  = true
  dependency_update = true
  wait              = true
  timeout           = 180
  atomic            = true
}