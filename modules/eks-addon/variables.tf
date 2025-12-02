variable "cluster_name" {
  description = "EKS 클러스터 이름"
  type        = string
}

variable "vpc_cni_role_arn" {
  description = "VPC CNI 역할 ARN"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}