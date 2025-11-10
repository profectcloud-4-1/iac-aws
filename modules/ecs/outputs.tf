output "id" {
  description = "ECS 클러스터 ID"
  value       = aws_ecs_cluster.this.id
}

output "arn" {
  description = "ECS 클러스터 ARN"
  value       = aws_ecs_cluster.this.arn
}

output "codedeploy_service_role_arn" {
  description = "CodeDeploy가 ECS 블루/그린 배포에 사용하는 Role ARN"
  value       = aws_iam_role.codedeploy_ecs.arn
}
