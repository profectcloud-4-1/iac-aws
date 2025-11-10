terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

locals {
  use_kms = var.encryption_type == "KMS" && var.kms_key_arn != null && var.kms_key_arn != ""
  common_tags = merge(
    {
      ManagedBy = "Terraform"
    },
    var.tags
  )
  # 기본 리텐션: 최근 2개 이미지만 유지
  default_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Retain only last 2 images (tagged or untagged)"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 2
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

resource "aws_ecr_repository" "this" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  dynamic "encryption_configuration" {
    for_each = local.use_kms ? [1] : []
    content {
      encryption_type = "KMS"
      kms_key         = var.kms_key_arn
    }
  }

  tags = local.common_tags
}

# 리텐션 정책
resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name
  policy     = var.lifecycle_policy_text != null ? var.lifecycle_policy_text : local.default_lifecycle_policy
}
