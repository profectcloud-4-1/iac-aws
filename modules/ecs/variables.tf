variable "cluster_name" {
  description = "ECS 클러스터 이름"
  type        = string
  default     = "goorm-ecs"
}

variable "enable_container_insights" {
  description = "CloudWatch Container Insights 활성화 여부"
  type        = bool
  default     = false
}

variable "enable_fargate_spot" {
  description = "FARGATE_SPOT 용량공급자 사용 여부"
  type        = bool
  default     = false
}

variable "service_connect_namespace_arn" {
  description = "Service Connect 기본 네임스페이스로 사용할 Cloud Map Namespace ARN"
  type        = string
  default     = ""
}

variable "tags" {
  description = "리소스 공통 태그"
  type        = map(string)
  default     = {}
}

