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
# resource "helm_release" "cert_manager" {
#   name              = "cert-manager"
#   repository        = "https://charts.jetstack.io"
#   chart             = "cert-manager"
#   namespace         = "cert-manager"
#   create_namespace  = true
#   dependency_update = true
#   wait              = true
#   timeout           = 180

#   values = [
#     yamlencode({
#       installCRDs = true
#       cainjector = {
#         nodeSelector = {
#           "karpenter.sh/nodepool" = "system"
#         }
#       }
#       webhook = {
#         nodeSelector = {
#           "karpenter.sh/nodepool" = "system"
#         }
#       }
#       "cert-manager" = {
#         nodeSelector = {
#           "karpenter.sh/nodepool" = "system"
#         }
#       }
#     })
#   ]
# }


