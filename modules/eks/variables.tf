variable "cluster_name" {
  description = "EKS 클러스터 이름 (리소스 네이밍에 사용)"
  type        = string
  default     = "goorm"
}

variable "cluster_version" {
  description = "EKS Kubernetes 버전"
  type        = string
  default     = "1.33"
}

variable "subnet_ids" {
  description = "EKS 클러스터가 사용할 서브넷 ID 목록 (예: private-app-a, private-app-b)"
  type        = list(string)
}

variable "enable_kube_state_metrics" {
  description = "kube-state-metrics를 Helm으로 배포할지 여부"
  type        = bool
  default     = true
}

variable "enable_node_exporter" {
  description = "prometheus-node-exporter를 Helm으로 배포할지 여부"
  type        = bool
  default     = true
}

variable "tags" {
  description = "공통 태그"
  type        = map(string)
  default     = {}
}

variable "enable_irsa_cni" {
  description = "VPC CNI 애드온(IRSA)용 역할 생성 여부"
  type        = bool
  default     = true
}

variable "oidc_provider_arn" {
  description = "EKS OIDC Provider ARN (IRSA 신뢰정책에 사용)"
  type        = string
  default     = null
}

variable "oidc_provider_url" {
  description = "EKS OIDC Issuer URL (예: https://oidc.eks.ap-northeast-2.amazonaws.com/id/XXXXXXXX)"
  type        = string
  default     = null
}


