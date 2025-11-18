variable "vpc_link_name" {
  description = "VPC Link 이름"
  type        = string
  default     = "goorm-vpc-link"
}

variable "vpc_link_security_group_id" {
  description = "VPC Link ENI에 적용할 보안그룹 ID (modules/security.vpc_link)"
  type        = string
}

variable "vpi_link_subnet_ids" {
  description = "VPC Link ENI가 둘 서브넷 ID 목록 (내부 NLB에 접근 가능한 서브넷)"
  type        = list(string)
}

variable "listener_arns" {
  description = "NLB 리스너 이름 => ARN 맵 (user_1, user_2, ...)"
  type        = map(string)
}

variable "payload_format_version" {
  description = "API Gateway 통합 Payload Format Version"
  type        = string
  default     = "1.0"
}

variable "integration_timeout_ms" {
  description = "통합 타임아웃 (밀리초)"
  type        = number
  default     = 29000
}

variable "authorizer_uri" {
  description = "Lambda Authorizer URI"
  type        = string
}