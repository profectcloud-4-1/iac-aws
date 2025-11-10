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
  default = "ap-northeast-2"
}

