variable "namespace" {
  description = "ArgoCD 네임스페이스"
  type        = string
  default     = "argocd"
}

variable "goormdotcom_namespace" {
  description = "Goormdotcom 네임스페이스"
  type        = string
  default     = "goormdotcom-prod"
}