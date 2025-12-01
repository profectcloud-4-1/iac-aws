variable "cluster_name" {
  description = "EKS 클러스터 이름"
  type        = string
}

variable "vpc_cni_role_arn" {
  description = "VPC CNI 역할 ARN"
  type        = string
}

variable "alb_controller_role_arn" {
  description = "ALB Controller(IRSA) 역할 ARN"
  type        = string
}

variable "external_secrets_operator_role_arn" {
  description = "External Secrets Operator(IRSA) 역할 ARN"
  type        = string
}