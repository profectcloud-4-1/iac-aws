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

variable "task_execution_role_arn" {
  description = "ECS Task Execution Role ARN (ECR Pull/Logs 권한)"
  type        = string
  default     = ""
}

variable "task_role_arn" {
  description = "ECS Task Role ARN (애플리케이션 권한)"
  type        = string
  default     = ""
}

variable "log_prefix" {
  description = "CloudWatch Logs 그룹 접두사"
  type        = string
  default     = "/ecs"
}

variable "service_task_configs" {
  description = "서비스별 태스크 설정(user/product/order/payment 각각 cpu, memory, container_port, image)"
  type = object({
    user = object({
      cpu            = number
      memory         = number
      container_port = number
      image          = string
    })
    product = object({ cpu = number, memory = number, container_port = number, image = string })
    order   = object({ cpu = number, memory = number, container_port = number, image = string })
    payment = object({ cpu = number, memory = number, container_port = number, image = string })
  })
  default = null
}

variable "prevent_destroy" {
  description = "Prevent destroy"
  type        = bool
  default     = false
}