
# ---------------------------------------
# IRSA Roles for Observability (Loki/Tempo/Mimir) - S3 access
# ---------------------------------------

resource "aws_iam_role" "log_s3" {
  name = "eks-irsa-log-s3"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = var.oidc_provider_arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${replace(var.oidc_issuer_url, "https://", "")}:aud" = "sts.amazonaws.com",
          "${replace(var.oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:observability:goormdotcom-log"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "log_s3" {
  role       = aws_iam_role.log_s3.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role" "trace_s3" {
  name = "eks-irsa-trace-s3"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = var.oidc_provider_arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${replace(var.oidc_issuer_url, "https://", "")}:aud" = "sts.amazonaws.com",
          "${replace(var.oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:observability:goormdotcom-trace"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "trace_s3" {
  role       = aws_iam_role.trace_s3.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role" "metric_s3" {
  name = "eks-irsa-metric-s3"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = var.oidc_provider_arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${replace(var.oidc_issuer_url, "https://", "")}:aud" = "sts.amazonaws.com",
          "${replace(var.oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:observability:goormdotcom-metric"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "metric_s3" {
  role       = aws_iam_role.metric_s3.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# ---------------------------------------
# IRSA Role for Grafana - CloudWatch access
# ---------------------------------------
resource "aws_iam_role" "grafana_cloudwatch" {
  name = "eks-irsa-grafana-cloudwatch"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = var.oidc_provider_arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${replace(var.oidc_issuer_url, "https://", "")}:aud" = "sts.amazonaws.com",
          "${replace(var.oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:observability:goormdotcom-grafana"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "grafana_cloudwatch_readonly" {
  role       = aws_iam_role.grafana_cloudwatch.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "grafana_cloudwatchlogs_readonly" {
  role       = aws_iam_role.grafana_cloudwatch.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsReadOnlyAccess"
}

# ---------------------------------------
# IRSA Role for OTEL Collector - CloudWatch Logs polling
# ---------------------------------------
resource "aws_iam_role" "otel_cloudwatch" {
  name = "eks-irsa-cloudwatch-log"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = var.oidc_provider_arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${replace(var.oidc_issuer_url, "https://", "")}:aud" = "sts.amazonaws.com",
          "${replace(var.oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:observability:goormdotcom-cloudwatch-log"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "otel_cloudwatchlogs_readonly" {
  role       = aws_iam_role.otel_cloudwatch.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsReadOnlyAccess"
}