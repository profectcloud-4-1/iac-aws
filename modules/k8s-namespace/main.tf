

resource "kubernetes_namespace" "goormdotcom" {
  metadata {
    name = "goormdotcom-prod"
  }
}

resource "kubernetes_namespace" "cert-manager" {
    metadata {
        name = "cert-manager"
    }
}

resource "kubernetes_namespace" "external_secrets" {
  metadata {
    name = "external-secrets"
  }
}

resource "kubernetes_namespace" "observability" {
  metadata {
    name = "observability"
  }
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}
