output "log_s3_role_arn" {
  description = "Log S3(IRSA) 역할 ARN"
  value       = aws_iam_role.log_s3.arn
}

output "trace_s3_role_arn" {
  description = "Trace S3(IRSA) 역할 ARN"
  value       = aws_iam_role.trace_s3.arn
}

output "metric_s3_role_arn" {
  description = "Metric S3(IRSA) 역할 ARN"
  value       = aws_iam_role.metric_s3.arn
}

output "otel_cloudwatch_role_arn" {
  description = "OTEL Collector CloudWatch Logs(IRSA) 역할 ARN"
  value       = aws_iam_role.otel_cloudwatch.arn
}