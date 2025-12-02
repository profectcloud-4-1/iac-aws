
output "created_namespaces" {
    value = {
        goormdotcom = kubernetes_namespace.goormdotcom.metadata[0].name
        cert-manager = kubernetes_namespace.cert-manager.metadata[0].name
        external-secrets = kubernetes_namespace.external-secrets.metadata[0].name
        observability = kubernetes_namespace.observability.metadata[0].name
        argocd = kubernetes_namespace.argocd.metadata[0].name
    }
}