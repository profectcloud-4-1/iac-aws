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
          tagStatus  = "any"
          countType  = "imageCountMoreThan"
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

# Pull 전용 정책
data "aws_iam_policy_document" "pull" {
  statement {
    sid     = "GetAuthorizationToken"
    actions = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid = "PullFromRepository"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:ListImages"
    ]
    resources = [aws_ecr_repository.this.arn]
  }
}

resource "aws_iam_policy" "pull" {
  name        = "ecr-pull"
  description = "Allow pulling images"
  policy      = data.aws_iam_policy_document.pull.json
  tags        = local.common_tags
}

# Push 전용 정책
data "aws_iam_policy_document" "push" {
  statement {
    sid     = "GetAuthorizationToken"
    actions = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid = "PushToRepository"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages"
    ]
    resources = [aws_ecr_repository.this.arn]
  }
}

resource "aws_iam_policy" "push" {
  name        = "ecr-push"
  description = "Allow pushing images"
  policy      = data.aws_iam_policy_document.push.json
  tags        = local.common_tags
}

