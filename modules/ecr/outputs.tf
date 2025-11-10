output "repository_url" {
  value = aws_ecr_repository.this.repository_url
}

output "repository_arn" {
  value = aws_ecr_repository.this.arn
}

output "pull_policy_arn" {
  value = aws_iam_policy.pull.arn
}

output "push_policy_arn" {
  value = aws_iam_policy.push.arn
}

