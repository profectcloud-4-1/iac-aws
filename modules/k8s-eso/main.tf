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


# ---------------------------------------
# External Secrets Operator (Helm) - use precreated SA
# ---------------------------------------
resource "kubernetes_namespace" "external_secrets" {
  metadata {
    name = "external-secrets"
  }
}

locals {
  eso_sa_name = "external-secrets-operator"
}

resource "kubernetes_service_account" "external_secrets_operator" {
  metadata {
    name      = local.eso_sa_name
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
      installCRDs = true
      serviceAccount = {
        create = false
        name   = local.eso_sa_name
      }
    })
  ]

  depends_on = [
    kubernetes_namespace.external_secrets,
    kubernetes_service_account.external_secrets_operator,
  ]
}

# SecretStore (AWS Secrets Manager)
resource "kubectl_manifest" "aws_secretstore" {
  yaml_body = <<EOF
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: aws-secrets
spec:
  provider:
    aws:
      service: SecretsManager
      region: ap-northeast-2
      auth:
        jwt:
          serviceAccountRef:
            name: ${local.eso_sa_name}
            namespace: external-secrets
EOF

  depends_on = [
    helm_release.external_secrets_operator
  ]
}

