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