
output "created_namespaces" {
  value = {
    goormdotcom      = local.ns_goormdotcom
    cert_manager     = local.ns_cert_manager
    external_secrets = local.ns_external_secrets
    observability    = local.ns_observability
    argocd           = local.ns_argocd
  }
}