terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
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
  namespace         = "argocd"
  create_namespace  = true
  dependency_update = true
  wait              = true
  timeout           = 600
}

# # ArgoCD Application Set
resource "kubectl_manifest" "msa_applicationset" {
  yaml_body = <<EOF
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: goormdotcom-applications
  namespace: argocd
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
      namespace: argocd
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
        namespace: goormdotcom-local
      syncPolicy:
        automated:
          prune: true
          selfHeal: true
        syncOptions:
          - CreateNamespace=false
          - ApplyOutOfSyncOnly=true
EOF
}




