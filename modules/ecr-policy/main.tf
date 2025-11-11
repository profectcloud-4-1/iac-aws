locals {
  common_tags = merge(
    {
      ManagedBy = "Terraform"
    },
    var.tags
  )
}

data "aws_iam_policy_document" "pull" {
  statement {
    sid       = "GetAuthorizationToken"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid = "PullFromRepositories"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:ListImages"
    ]
    resources = var.repository_arns
  }
}

resource "aws_iam_policy" "pull" {
  name        = "${var.name_prefix}-pull"
  description = "Allow pulling images from selected ECR repositories"
  policy      = data.aws_iam_policy_document.pull.json
  tags        = local.common_tags
}

data "aws_iam_policy_document" "push" {
  statement {
    sid       = "GetAuthorizationToken"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid = "PushToRepositories"
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
    resources = var.repository_arns
  }
}

resource "aws_iam_policy" "push" {
  name        = "${var.name_prefix}-push"
  description = "Allow pushing images to selected ECR repositories"
  policy      = data.aws_iam_policy_document.push.json
  tags        = local.common_tags
}

