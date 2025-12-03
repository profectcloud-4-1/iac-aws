
output "alb_controller_role_arn" {
  description = "ALB Controller(IRSA) 역할 ARN"
  value       = aws_iam_role.alb_controller.arn
}

output "external_secrets_operator_role_arn" {
  description = "External Secrets Operator(IRSA) 역할 ARN"
  value       = aws_iam_role.external_secrets_operator.arn
}
