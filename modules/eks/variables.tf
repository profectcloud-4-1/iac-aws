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

variable "tags" {
  description = "공통 태그"
  type        = map(string)
  default     = {}
}
