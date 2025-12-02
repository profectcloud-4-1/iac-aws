variable "tempo_host" {
  description = "Tempo host"
  type        = string
}

variable "mimir_host" {
  description = "Mimir host"
  type        = string
}

variable "loki_host" {
  description = "Loki host"
  type        = string
}

variable "k8s_cluster_name" {
  description = "Kubernetes cluster name"
  type        = string
}

variable "namespace" {
  description = "OpenTelemetry Collector 네임스페이스"
  type        = string
  default     = "observability"
}