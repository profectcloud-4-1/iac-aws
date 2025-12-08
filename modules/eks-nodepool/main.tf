resource "kubectl_manifest" "msa_nodepool" {
  yaml_body = file("msa-nodepool.yaml")
}
