variable "k8s_cluster_name" {
  description = "Kubernetes cluster name"
  type        = string
}

variable "namespace" {
  description = "OpenTelemetry Collector 네임스페이스"
  type        = string
  default     = "observability"
}