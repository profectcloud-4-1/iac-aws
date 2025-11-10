output "id" {
  description = "ECS 클러스터 ID"
  value       = aws_ecs_cluster.this.id
}

output "arn" {
  description = "ECS 클러스터 ARN"
  value       = aws_ecs_cluster.this.arn
}

