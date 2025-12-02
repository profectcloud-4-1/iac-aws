output "cluster_name" {
  description = "EKS 클러스터 이름"
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "EKS API 서버 엔드포인트"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  description = "클러스터 CA 데이터 (base64)"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

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

output "telemetry_backend_sa_role_arn" {
  description = "Telemetry Backend Service Account(IRSA) 역할 ARN"
  value       = aws_iam_role.telemetry_backend_sa.arn
}