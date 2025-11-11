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

variable "user_image" {
  type        = string
  description = "User service image"
  default     = "please-fill/imagename:tag"
}

variable "product_image" {
  type        = string
  description = "Product service image"
  default     = "please-fill/imagename:tag"
}

variable "order_image" {
  type        = string
  description = "Order service image"
  default     = "please-fill/imagename:tag"
}

variable "payment_image" {
  type        = string
  description = "Payment service image"
  default     = "please-fill/imagename:tag"
}

variable "cloudfront_domain_name" {
  type        = string
  description = "CloudFront domain name (예시: api.goorm.store)"

  validation {
    condition     = length(var.cloudfront_domain_name) > 0
    error_message = "CloudFront domain name is required"
  }
}

variable "presigned_bucket_name" {
  type        = string
  description = "Presigned bucket name (예시: goorm-presigned-bucket)"

  validation {
    condition     = length(var.presigned_bucket_name) > 0
    error_message = "Presigned bucket name is required"
  }
}