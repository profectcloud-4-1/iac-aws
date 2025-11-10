output "namespace_id" {
  description = "Cloud Map 프라이빗 DNS 네임스페이스 ID"
  value       = aws_service_discovery_private_dns_namespace.this.id
}

output "namespace_arn" {
  description = "Cloud Map 프라이빗 DNS 네임스페이스 ARN"
  value       = aws_service_discovery_private_dns_namespace.this.arn
}

output "namespace_hosted_zone" {
  description = "해당 네임스페이스의 Route53 호스티드존 ID"
  value       = aws_service_discovery_private_dns_namespace.this.hosted_zone
}

output "namespace_name" {
  description = "Cloud Map 프라이빗 DNS 네임스페이스 이름"
  value       = aws_service_discovery_private_dns_namespace.this.name
}

