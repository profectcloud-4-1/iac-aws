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
