variable "vpc_id" {
  description = "보안그룹을 생성할 VPC ID"
  type        = string
}

variable "name_prefix" {
  description = "보안그룹 이름 접두사"
  type        = string
  default     = "goorm"
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  type        = string
}