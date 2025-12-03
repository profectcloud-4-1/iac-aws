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

locals {
  sa_names = {
    loki  = "loki"
    tempo = "tempo"
    mimir = "mimir"
  }
  bucket_names = {
    loki  = var.s3_bucket_loki
    tempo = var.s3_bucket_tempo
    mimir = var.s3_bucket_mimir
  }
  grafana_repo = "https://grafana.github.io/helm-charts"
  s3_endpoint  = var.s3_endpoint
}

# ---------------------------------------
# ServiceAccounts (IRSA annotations)
# ---------------------------------------
resource "kubernetes_service_account" "loki" {
  metadata {
    name      = local.sa_names.loki
    namespace = var.namespace
    annotations = length(var.loki_s3_role_arn) > 0 ? {
      "eks.amazonaws.com/role-arn" = var.loki_s3_role_arn
    } : null
  }
  automount_service_account_token = true
}

resource "kubernetes_service_account" "tempo" {
  metadata {
    name      = local.sa_names.tempo
    namespace = var.namespace
    annotations = length(var.tempo_s3_role_arn) > 0 ? {
      "eks.amazonaws.com/role-arn" = var.tempo_s3_role_arn
    } : null
  }
  automount_service_account_token = true
}

resource "kubernetes_service_account" "mimir" {
  metadata {
    name      = local.sa_names.mimir
    namespace = var.namespace
    annotations = length(var.mimir_s3_role_arn) > 0 ? {
      "eks.amazonaws.com/role-arn" = var.mimir_s3_role_arn
    } : null
  }
  automount_service_account_token = true
}

# ---------------------------------------
# Optional S3 Buckets
# ---------------------------------------


# S3 buckets for Loki, Tempo, Mimir
resource "aws_s3_bucket" "telemetry" {
  for_each      = local.bucket_names
  bucket        = each.value
  force_destroy = true

  tags = {
    Name = each.value
  }
}

resource "aws_s3_bucket_versioning" "telemetry" {
  for_each = aws_s3_bucket.telemetry
  bucket   = each.value.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "telemetry" {
  for_each = aws_s3_bucket.telemetry
  bucket   = each.value.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "telemetry" {
  for_each = aws_s3_bucket.telemetry
  bucket   = each.value.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ---------------------------------------
# Helm Releases
# ---------------------------------------

# Loki (monolithic)
resource "helm_release" "loki" {
  name             = "loki"
  repository       = local.grafana_repo
  chart            = "loki"
  namespace        = var.namespace
  create_namespace = false
  timeout          = 180
  atomic           = true

  version = var.loki_chart_version == "" ? null : var.loki_chart_version

  values = [
    yamlencode({

      #######################################################
      # Service Account (IRSA)
      #######################################################
      serviceAccount = {
        create = false
        name   = local.sa_names.loki
      }

      #######################################################
      # Monolithic Loki Mode
      #######################################################
      deploymentMode = "SingleBinary"

      singleBinary = {
        replicas = 1
        persistence = {
          enabled = false
        }
      }

      #######################################################
      # MinIO 끄기 (S3 직접 사용)
      #######################################################
      minio = {
        enabled = false
      }
      chunksCache = {
        enabled = false
      }
      resultsCache = {
        enabled = false
      }
      memberlist = {
        enabled = false
      }

      #######################################################
      # Loki main config
      #######################################################
      loki = {
        authEnabled = false

        commonConfig = {
          replication_factor = 1
        }

        # TSDB 기반 스키마
        schemaConfig = {
          configs = [
            {
              from         = "2024-04-01"
              store        = "boltdb-shipper"
              object_store = "s3"
              schema       = "v13"
              index = {
                prefix = "loki_index_"
                period = "24h"
              }
            }
          ]
        }

        pattern_ingester = {
          enabled = true
        }

        limits_config = {
          allow_structured_metadata = false
          volume_enabled            = true
        }

        ruler = {
          enable_api = true
        }

        #######################################################
        # === S3 저장소 설정 ===
        #######################################################
        storage = {
          type = "s3"

          bucketNames = {
            chunks = local.bucket_names.loki
            ruler  = local.bucket_names.loki
            admin  = local.bucket_names.loki
          }

          s3 = {
            endpoint         = "https://s3.ap-northeast-2.amazonaws.com"
            region           = "ap-northeast-2"
            s3ForcePathStyle = false # AWS S3는 반드시 false
            insecure         = false
          }
        }
      }

      #######################################################
      # Disable ALL distributed mode components
      #######################################################
      backend        = { replicas = 0 }
      read           = { replicas = 0 }
      write          = { replicas = 0 }
      ingester       = { replicas = 0 }
      querier        = { replicas = 0 }
      queryFrontend  = { replicas = 0 }
      queryScheduler = { replicas = 0 }
      distributor    = { replicas = 0 }
      compactor      = { replicas = 0 }
      indexGateway   = { replicas = 0 }
      bloomCompactor = { replicas = 0 }
      bloomGateway   = { replicas = 0 }

    })
  ]

  depends_on = [
    kubernetes_service_account.loki,
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
        name   = local.sa_names.tempo
      }
      # small, single-replica footprint (chart-level keys)
      distributor   = { replicaCount = 1 }
      ingester      = { replicaCount = 1 }
      querier       = { replicaCount = 1 }
      queryFrontend = { replicaCount = 1 }
      compactor     = { replicaCount = 1 }
      tempo = {
        metricsGenerator = { enabled = false }
        storage = {
          trace = {
            backend = "s3"
            s3 = {
              bucket         = local.bucket_names.tempo
              region         = var.aws_region
              endpoint       = local.s3_endpoint
              forcepathstyle = var.s3_force_path_style
            }
          }
        }
      }
    })
  ]

  depends_on = [
    kubernetes_service_account.tempo,
  ]
}

# Mimir (minimum)
resource "kubernetes_manifest" "mimir_config" {
  manifest = yamldecode(templatefile("${path.module}/mimir/configmap.yaml", {
    BUCKET = local.bucket_names.mimir
  }))
}

resource "kubernetes_manifest" "mimir_deployment" {
  manifest = yamldecode(templatefile("${path.module}/mimir/deployment.yaml", {
    SA_NAME = local.sa_names.mimir
  }))
  depends_on = [kubernetes_manifest.mimir_config, kubernetes_service_account.mimir]
}

resource "kubernetes_manifest" "mimir_service" {
  manifest   = yamldecode(file("${path.module}/mimir/service.yaml"))
  depends_on = [kubernetes_manifest.mimir_deployment]
}

