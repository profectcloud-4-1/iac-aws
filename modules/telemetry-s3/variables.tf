variable "aws_region" {
  description = "S3가 위치한 AWS 리전"
  type        = string
}

variable "s3_bucket_loki" {
  description = "Loki가 사용할 S3 버킷 이름"
  type        = string
  default     = "goormdotcom-log"
}

variable "s3_bucket_tempo" {
  description = "Tempo가 사용할 S3 버킷 이름"
  type        = string
  default     = "goormdotcom-trace"
}

variable "s3_bucket_mimir" {
  description = "Mimir가 사용할 S3 버킷 이름"
  type        = string
  default     = "goormdotcom-metric"
}

variable "oidc_provider_arn" {
  description = "클러스터 OIDC 공급자 ARN"
  type        = string
}

variable "oidc_issuer_url" {
  description = "클러스터 OIDC 발급자 URL"
  type        = string
}