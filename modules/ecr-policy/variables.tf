variable "repository_arns" {
  description = "허용할 ECR 리포지토리 ARN 목록"
  type        = list(string)
}

variable "name_prefix" {
  description = "정책 이름 접두사"
  type        = string
  default     = "ecr"
}

variable "tags" {
  description = "공통 태그"
  type        = map(string)
  default     = {}
}

