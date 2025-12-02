variable "cluster_name" {
  description = "EKS 클러스터 이름"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "alb_controller_role_arn" {
  description = "ALB Controller(IRSA) 역할 ARN"
  type        = string
}

variable "goormdotcom_namespace" {
  description = "Goormdotcom 네임스페이스"
  type        = string
  default     = "goormdotcom-prod"
}

variable "observability_namespace" {
  description = "Observability 네임스페이스"
  type        = string
  default     = "observability"
}