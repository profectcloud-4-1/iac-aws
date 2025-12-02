
output "created_namespaces" {
  value = {
    goormdotcom      = kubernetes_namespace.goormdotcom.metadata[0].name
    cert_manager     = kubernetes_namespace.cert_manager.metadata[0].name
    external_secrets = kubernetes_namespace.external_secrets.metadata[0].name
    observability    = kubernetes_namespace.observability.metadata[0].name
    argocd           = kubernetes_namespace.argocd.metadata[0].name
  }
}