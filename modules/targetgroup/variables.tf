variable "vpc_id" {
  description = "타깃그룹을 생성할 VPC ID"
  type        = string
}

variable "services" {
  description = "서비스 이름 목록 (예: [\"user\",\"product\",\"order\",\"payment\"])"
  type        = list(string)
  default     = ["user", "product", "order", "payment"]
}

variable "replicas_per_service" {
  description = "각 서비스당 타깃그룹 개수(Blue/Green=2)"
  type        = number
  default     = 2
}

variable "name_prefix" {
  description = "타깃그룹 이름 접두사"
  type        = string
  default     = "tg"
}

variable "protocol" {
  description = "트래픽 프로토콜 (NLB TCP)"
  type        = string
  default     = "TCP"
}

variable "port" {
  description = "타깃 포트"
  type        = number
  default     = 8080
}

variable "target_type" {
  description = "타깃 타입 (ip)"
  type        = string
  default     = "ip"
}

variable "health_check_protocol" {
  description = "헬스체크 프로토콜 (HTTP)"
  type        = string
  default     = "HTTP"
}

variable "health_check_path" {
  description = "헬스체크 경로"
  type        = string
  default     = "/actuator/health"
}

