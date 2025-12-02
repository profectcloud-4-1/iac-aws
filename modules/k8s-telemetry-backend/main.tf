terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# ---------------------------------------
# Namespace
# ---------------------------------------
resource "kubernetes_namespace" "telemetry" {
  metadata {
    name = var.namespace
  }
}

locals {
  loki_sa_name  = "loki"
  tempo_sa_name = "tempo"
  mimir_sa_name = "mimir"
}

# ---------------------------------------
# ServiceAccounts (IRSA annotations)
# ---------------------------------------
resource "kubernetes_service_account" "loki" {
  metadata {
    name      = local.loki_sa_name
    namespace = var.namespace
    annotations = length(var.loki_sa_role_arn) > 0 ? {
      "eks.amazonaws.com/role-arn" = var.loki_sa_role_arn
    } : null
  }
  automount_service_account_token = true
}

resource "kubernetes_service_account" "tempo" {
  metadata {
    name      = local.tempo_sa_name
    namespace = var.namespace
    annotations = length(var.tempo_sa_role_arn) > 0 ? {
      "eks.amazonaws.com/role-arn" = var.tempo_sa_role_arn
    } : null
  }
  automount_service_account_token = true
}

resource "kubernetes_service_account" "mimir" {
  metadata {
    name      = local.mimir_sa_name
    namespace = var.namespace
    annotations = length(var.mimir_sa_role_arn) > 0 ? {
      "eks.amazonaws.com/role-arn" = var.mimir_sa_role_arn
    } : null
  }
  automount_service_account_token = true
}

# ---------------------------------------
# Optional S3 Buckets
# ---------------------------------------
resource "aws_s3_bucket" "loki" {
  count  = var.create_buckets ? 1 : 0
  bucket = var.s3_bucket_loki
}

resource "aws_s3_bucket" "tempo" {
  count  = var.create_buckets ? 1 : 0
  bucket = var.s3_bucket_tempo
}

resource "aws_s3_bucket" "mimir" {
  count  = var.create_buckets ? 1 : 0
  bucket = var.s3_bucket_mimir
}

resource "aws_s3_bucket_versioning" "loki" {
  count  = var.create_buckets ? 1 : 0
  bucket = aws_s3_bucket.loki[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "tempo" {
  count  = var.create_buckets ? 1 : 0
  bucket = aws_s3_bucket.tempo[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "mimir" {
  count  = var.create_buckets ? 1 : 0
  bucket = aws_s3_bucket.mimir[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "loki" {
  count  = var.create_buckets ? 1 : 0
  bucket = aws_s3_bucket.loki[0].id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tempo" {
  count  = var.create_buckets ? 1 : 0
  bucket = aws_s3_bucket.tempo[0].id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "mimir" {
  count  = var.create_buckets ? 1 : 0
  bucket = aws_s3_bucket.mimir[0].id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ---------------------------------------
# Helm Releases
# ---------------------------------------
locals {
  grafana_repo = "https://grafana.github.io/helm-charts"
  s3_endpoint  = var.s3_endpoint == "" ? null : var.s3_endpoint
}

# Loki (monolithic)
resource "helm_release" "loki" {
  name             = "loki"
  repository       = local.grafana_repo
  chart            = "loki"
  namespace        = var.namespace
  create_namespace = false
  timeout          = 180
  atomic           = true
  # if provided
  version = var.loki_chart_version == "" ? null : var.loki_chart_version

  values = [
    yamlencode({
      serviceAccount = {
        create = false
        name   = local.loki_sa_name
      }
      persistence = {
        enabled = true
        size    = "50Gi"
      }
      loki = {
        config = <<-EOT
          auth_enabled: false
          server:
            http_listen_port: 3100
          schema_config:
            configs:
            - from: "2023-01-01"
              store: boltdb-shipper
              object_store: s3
              schema: v13
              index:
                prefix: loki_index_
                period: 24h
          storage_config:
            boltdb_shipper:
              shared_store: s3
              active_index_directory: /var/loki/index
              cache_location: /var/loki/index_cache
            s3:
              bucket: "${var.s3_bucket_loki}"
              region: "${var.aws_region}"
              s3forcepathstyle: ${var.s3_force_path_style}
              ${local.s3_endpoint == null ? "" : "endpoint: \"${local.s3_endpoint}\""}
        EOT
      }
    })
  ]

  depends_on = [
    kubernetes_service_account.loki,
    kubernetes_namespace.telemetry
  ]
}

# Tempo
resource "helm_release" "tempo" {
  name             = "tempo"
  repository       = local.grafana_repo
  chart            = "tempo"
  namespace        = var.namespace
  create_namespace = false
  timeout          = 180
  atomic           = true
  version          = var.tempo_chart_version == "" ? null : var.tempo_chart_version

  values = [
    yamlencode({
      serviceAccount = {
        create = false
        name   = local.tempo_sa_name
      }
      tempo = {
        storage = {
          trace = {
            backend = "s3"
            s3 = {
              bucket           = var.s3_bucket_tempo
              region           = var.aws_region
              s3forcepathstyle = var.s3_force_path_style
              endpoint         = local.s3_endpoint
            }
          }
        }
      }
    })
  ]

  depends_on = [
    kubernetes_service_account.tempo,
    kubernetes_namespace.telemetry
  ]
}

# Mimir (distributed)
resource "helm_release" "mimir" {
  name             = "mimir"
  repository       = local.grafana_repo
  chart            = "mimir-distributed"
  namespace        = var.namespace
  create_namespace = false
  timeout          = 900
  atomic           = true
  version          = var.mimir_chart_version == "" ? null : var.mimir_chart_version

  values = [
    yamlencode({
      serviceAccount = {
        create = false
        name   = local.mimir_sa_name
      }
      mimir = {
        # structuredConfig는 최신 차트에서 권장됨
        structuredConfig = {
          blocks_storage = {
            backend = "s3"
            s3 = {
              bucket_name      = var.s3_bucket_mimir
              region           = var.aws_region
              s3forcepathstyle = var.s3_force_path_style
              endpoint         = local.s3_endpoint
            }
          }
          ruler_storage = {
            backend = "s3"
            s3 = {
              bucket_name      = var.s3_bucket_mimir
              region           = var.aws_region
              s3forcepathstyle = var.s3_force_path_style
              endpoint         = local.s3_endpoint
            }
          }
          alertmanager_storage = {
            backend = "s3"
            s3 = {
              bucket_name      = var.s3_bucket_mimir
              region           = var.aws_region
              s3forcepathstyle = var.s3_force_path_style
              endpoint         = local.s3_endpoint
            }
          }
        }
      }
    })
  ]

  depends_on = [
    kubernetes_service_account.mimir,
    kubernetes_namespace.telemetry
  ]
}