output "distribution_id" {
  description = "CloudFront 배포 ID"
  value       = aws_cloudfront_distribution.this.id
}

output "distribution_domain_name" {
  description = "CloudFront 배포 도메인"
  value       = aws_cloudfront_distribution.this.domain_name
}

