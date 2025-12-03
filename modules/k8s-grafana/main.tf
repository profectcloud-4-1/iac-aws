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

locals {
  grafana_repo = "https://grafana.github.io/helm-charts"
}

# ---------------------------------------
# Grafana (Helm)
# - Ingress는 차트 대신 별도 Ingress 리소스로 생성 (ALB 호스트 미지정 대응)
# ---------------------------------------
resource "helm_release" "grafana" {
  name              = "grafana"
  repository        = local.grafana_repo
  chart             = "grafana"
  namespace         = var.namespace
  create_namespace  = false
  dependency_update = true
  wait              = true
  timeout           = 120
  atomic            = true
  version           = var.chart_version == "" ? null : var.chart_version

  values = [
    yamlencode({
      fullnameOverride = "grafana"
      adminPassword    = var.admin_password
      env = {
        GF_SERVER_ROOT_URL            = "%(protocol)s://%(domain)s/grafana"
        GF_SERVER_SERVE_FROM_SUB_PATH = "true"
      }
      persistence = {
        enabled = false
      }
      service = {
        type = "ClusterIP"
        port = 80
      }
      ingress = {
        enabled = false
      }
      # Datasource provisioning
      datasources = {
        "datasources.yaml" = {
          apiVersion = 1
          datasources = [
            {
              name      = "Loki"
              type      = "loki"
              access    = "proxy"
              url       = "http://${var.loki_host}:${var.loki_port}"
              isDefault = false
            },
            {
              name      = "Tempo"
              type      = "tempo"
              access    = "proxy"
              url       = "http://${var.tempo_host}:${var.tempo_port}"
              isDefault = false
            },
            {
              name      = "Mimir"
              type      = "prometheus"
              access    = "proxy"
              url       = "http://${var.mimir_host}:${var.mimir_port}${var.mimir_path}"
              isDefault = false
            }
          ]
        }
      }
    })
  ]

  depends_on = [
    kubernetes_namespace.grafana
  ]
}
