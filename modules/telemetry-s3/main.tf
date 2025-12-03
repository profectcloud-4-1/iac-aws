# =========================================
# Telemetry S3 Buckets
# IRSA 생성
# goormdotcom-log, goormdotcom-trace, goormdotcom-metric 3개 S3 버킷 생성
# =========================================

locals {
  bucket_names = {
    log    = var.s3_bucket_loki
    trace  = var.s3_bucket_tempo
    metric = var.s3_bucket_mimir
  }
}

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