variable "db_master_username" {
  description = "RDS 마스터 사용자명 (모든 서비스 공통 사용 가능)"
  type        = string
  sensitive   = true
}

variable "db_master_password" {
  description = "RDS 마스터 비밀번호 (모든 서비스 공통 사용 가능)"
  type        = string
  sensitive   = true
}
variable "aws_region" {
  type        = string
  description = "AWS region for provider"
  default     = "ap-northeast-2"
}

variable "presigned_bucket_name" {
  type        = string
  description = "Presigned bucket name (예시: goorm-presigned-bucket)"

  validation {
    condition     = length(var.presigned_bucket_name) > 0
    error_message = "Presigned bucket name is required"
  }
}

variable "authorizer_uri" {
  description = "Lambda Authorizer URI"
  type        = string
}