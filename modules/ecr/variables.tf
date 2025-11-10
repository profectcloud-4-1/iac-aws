variable "repository_name" {
  description = "ECR 리포지토리 이름 (namespace/repository-name)"
  type        = string
}

variable "image_tag_mutability" {
  description = "태그 변경 허용 여부 (MUTABLE 또는 IMMUTABLE)"
  type        = string
  default     = "IMMUTABLE"
}

variable "scan_on_push" {
  description = "이미지 푸시 시 보안 스캔 여부"
  type        = bool
  default     = true
}

variable "encryption_type" {
  description = "암호화 방식 (AES256 또는 KMS)"
  type        = string
  default     = "AES256"
}

variable "kms_key_arn" {
  description = "KMS 사용 시 KMS 키 ARN"
  type        = string
  default     = null
}

variable "lifecycle_policy_text" {
  description = "리포지토리 라이프사이클 정책(JSON 문자열). 없으면 생성 안 함"
  type        = string
  default     = null
}

variable "tags" {
  description = "공통 태그"
  type        = map(string)
  default     = {}
}

