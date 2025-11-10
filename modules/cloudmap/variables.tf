variable "vpc_id" {
  description = "Cloud Map 프라이빗 DNS 네임스페이스를 생성할 VPC ID"
  type        = string
}

variable "namespace_name" {
  description = "프라이빗 DNS 네임스페이스 이름 (예: prod.goormdotcom)"
  type        = string
  default     = "prod.goormdotcom"
}

variable "description" {
  description = "네임스페이스 설명"
  type        = string
  default     = "Private DNS namespace for ECS service discovery"
}

variable "tags" {
  description = "리소스에 적용할 공통 태그"
  type        = map(string)
  default     = {}
}

