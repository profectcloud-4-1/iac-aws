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
  }
}

# #
# # CRDs 선적용 (일부 환경에서 chart의 installCRDs=true가 race를 유발함)
# #
# data "http" "eso_crds" {
#   url = "https://raw.githubusercontent.com/external-secrets/external-secrets/main/deploy/crds/bundle.yaml"
# }

# resource "kubectl_manifest" "eso_crds" {
#   yaml_body = data.http.eso_crds.response_body
# }


# ---------------------------------------
# External Secrets Operator (Helm) - use precreated SA
# ---------------------------------------

locals {
  eso_sa_name = "external-secrets-operator"
}

resource "kubernetes_service_account" "external_secrets_operator" {
  metadata {
    name      = local.eso_sa_name
    namespace = var.namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = var.external_secrets_operator_role_arn
    }
  }
}

resource "helm_release" "external_secrets_operator" {
  name              = "external-secrets-operator"
  repository        = "https://charts.external-secrets.io"
  chart             = "external-secrets"
  namespace         = var.namespace
  create_namespace  = false
  dependency_update = true
  wait              = true
  timeout           = 120
  atomic            = true

  values = [
    yamlencode({
      installCRDs = true
      serviceAccount = {
        create = false
        name   = local.eso_sa_name
      }
    })
  ]

  depends_on = [
    kubernetes_service_account.external_secrets_operator,
  ]
}

# SecretStore (AWS Secrets Manager)
resource "kubectl_manifest" "aws_secretstore" {
  yaml_body = <<EOF
apiVersion: external-secrets.io/v1
kind: ClusterSecretStore
metadata:
  name: goorm-app-secret-store
spec:
  provider:
    aws:
      service: SecretsManager
      region: ap-northeast-2
      auth:
        jwt:
          serviceAccountRef:
            name: ${local.eso_sa_name}
            namespace: ${var.namespace}
EOF

  depends_on = [
    helm_release.external_secrets_operator
  ]
}

