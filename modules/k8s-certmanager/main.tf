terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}

# ---------------------------------------
# Cert Manager
# ---------------------------------------
resource "helm_release" "cert_manager" {
  name              = "cert-manager"
  repository        = "https://charts.jetstack.io"
  chart             = "cert-manager"
  namespace         = "cert-manager"
  create_namespace  = true
  dependency_update = true
  wait              = true
  timeout           = 600
}

resource "null_resource" "wait_cert_manager" {
  depends_on = [helm_release.cert_manager]

  provisioner "local-exec" {
    command = <<EOT
kubectl rollout status deploy/cert-manager-webhook -n cert-manager --timeout=10m
EOT
  }
}

# Cert Manager - Issuer wait
resource "null_resource" "wait_cert_manager_issuer" {
  depends_on = [null_resource.wait_cert_manager]

  provisioner "local-exec" {
    command = <<EOT
kubectl rollout status deploy/cert-manager-cainjector -n cert-manager --timeout=10m
EOT
  }
}

# Cert Manager - ClusterIssuer wait
resource "null_resource" "wait_cert_manager_cluster_issuer" {
  depends_on = [null_resource.wait_cert_manager_issuer]

  provisioner "local-exec" {
    command = <<EOT
kubectl rollout status deploy/cert-manager-cluster-issuer -n cert-manager --timeout=10m
EOT
  }
}
