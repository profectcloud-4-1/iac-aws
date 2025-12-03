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
  }
}

# ---------------------------------------
# ArgoCD (Helm)
# ---------------------------------------
resource "helm_release" "argocd" {
  name              = "argocd"
  repository        = "https://argoproj.github.io/argo-helm"
  chart             = "argo-cd"
  namespace         = var.namespace
  create_namespace  = false
  dependency_update = true
  wait              = true
  timeout           = 180
}

# # ArgoCD Application Set
resource "kubectl_manifest" "msa_applicationset" {
  yaml_body = <<EOF
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: goormdotcom-applications
  namespace: ${var.namespace}
spec:
  generators:
    - list:
        elements:
          - name: auth-gateway
            valuesFile: ../../app/auth/values.yaml
          - name: user
            valuesFile: ../../app/user/values.yaml
          - name: product
            valuesFile: ../../app/product/values.yaml
          - name: order
            valuesFile: ../../app/order/values.yaml
          - name: payment
            valuesFile: ../../app/payment/values.yaml

  template:
    metadata:
      name: "{{name}}"
      namespace: ${var.namespace}
    spec:
      project: default
      source:
        repoURL: https://github.com/profectcloud-4-1/gitops-app.git
        targetRevision: main
        path: chart/goorm-app
        helm:
          valueFiles:
            - "{{valuesFile}}"
      destination:
        server: https://kubernetes.default.svc
        namespace: ${var.goormdotcom_namespace}
      syncPolicy:
        automated:
          prune: true
          selfHeal: true
        syncOptions:
          - CreateNamespace=false
          - ApplyOutOfSyncOnly=true
EOF
}




