output "vpc_cni_role_arn" {
  description = "VPC CNI 역할 ARN"
  value       = aws_iam_role.vpc_cni.arn
}

output "alb_controller_role_arn" {
  description = "ALB Controller(IRSA) 역할 ARN"
  value       = aws_iam_role.alb_controller.arn
}

output "external_secrets_operator_role_arn" {
  description = "External Secrets Operator(IRSA) 역할 ARN"
  value       = aws_iam_role.external_secrets_operator.arn
}

output "loki_s3_role_arn" {
  description = "Loki S3(IRSA) 역할 ARN"
#   value       = aws_iam_role.loki_s3.arn
  value       = ""
}

output "tempo_s3_role_arn" {
  description = "Tempo S3(IRSA) 역할 ARN"
#   value       = aws_iam_role.tempo_s3.arn
  value       = ""
}

output "mimir_s3_role_arn" {
  description = "Mimir S3(IRSA) 역할 ARN"
#   value       = aws_iam_role.mimir_s3.arn
  value       = ""
}