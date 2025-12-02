terraform {
  required_providers {
    kubectl = {
      source = "alekc/kubectl"
    }
  }
}

locals {
  ns_goormdotcom      = "goormdotcom-prod"
  ns_cert_manager     = "cert-manager"
  ns_external_secrets = "external-secrets"
  ns_observability    = "observability"
  ns_argocd           = "argocd"
}

resource "kubectl_manifest" "goormdotcom" {
  yaml_body = <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: ${local.ns_goormdotcom}
EOF
}

resource "kubectl_manifest" "cert_manager" {
  yaml_body = <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: ${local.ns_cert_manager}
EOF
}

resource "kubectl_manifest" "external_secrets" {
  yaml_body = <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: ${local.ns_external_secrets}
EOF
}

resource "kubectl_manifest" "observability" {
  yaml_body = <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: ${local.ns_observability}
EOF
}

resource "kubectl_manifest" "argocd" {
  yaml_body = <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: ${local.ns_argocd}
EOF
}
