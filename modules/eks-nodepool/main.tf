terraform {
  required_providers {
  kubectl = {
      source = "alekc/kubectl"
    }
  }
}

resource "kubectl_manifest" "msa_nodepool" {
  yaml_body = file("${path.module}/msa-nodepool.yaml")
}

resource "kubectl_manifest" "observability_nodepool" {
  yaml_body = file("${path.module}/observability-nodepool.yaml")
}