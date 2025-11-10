output "target_group_arns" {
  description = "생성된 타깃그룹 이름 => ARN 매핑"
  value       = { for k, tg in aws_lb_target_group.this : k => tg.arn }
}

output "target_group_names" {
  description = "생성된 타깃그룹 이름 목록"
  value       = keys(aws_lb_target_group.this)
}

