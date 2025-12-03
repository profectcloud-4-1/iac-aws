variable "namespace" {
  description = "OpenTelemetry Gateway Collector 네임스페이스"
  type        = string
  default     = "observability"
}

variable "image" {
  description = "OpenTelemetry Collector 이미지"
  type        = string
  default     = "otel/opentelemetry-collector-contrib:0.112.0"
}

variable "replicas_logs" {
  description = "Gateway Collector Logs replica 수"
  type        = number
  default     = 2
}

variable "replicas_traces" {
  description = "Gateway Collector Traces replica 수"
  type        = number
  default     = 2
}

variable "replicas_metrics" {
  description = "Gateway Collector Metrics replica 수"
  type        = number
  default     = 2
}

variable "kafka_brokers" {
  description = "Kafka broker 주소 리스트"
  type        = list(string)
}

variable "kafka_topic_logs" {
  description = "Kafka logs topic 이름"
  type        = string
  default     = "system_log"
}

variable "kafka_topic_traces" {
  description = "Kafka traces topic 이름"
  type        = string
  default     = "trace"
}

variable "kafka_topic_metrics" {
  description = "Kafka metrics topic 이름"
  type        = string
  default     = "metric"
}

variable "loki_host" {
  description = "Loki 호스트 주소"
  type        = string
}

variable "tempo_host" {
  description = "Tempo 호스트 주소"
  type        = string
}

variable "mimir_host" {
  description = "Mimir 호스트 주소"
  type        = string
}

variable "deployment_env" {
  description = "배포 환경 이름 (예: prod, dev, staging)"
  type        = string
  default     = "prod"
}

# Resource limits and requests for Logs collector
variable "cpu_limit_logs" {
  description = "CPU limit for Logs collector"
  type        = string
  default     = "1000m"
}

variable "memory_limit_logs" {
  description = "Memory limit for Logs collector"
  type        = string
  default     = "2Gi"
}

variable "cpu_request_logs" {
  description = "CPU request for Logs collector"
  type        = string
  default     = "500m"
}

variable "memory_request_logs" {
  description = "Memory request for Logs collector"
  type        = string
  default     = "1Gi"
}

# Resource limits and requests for Traces collector
variable "cpu_limit_traces" {
  description = "CPU limit for Traces collector"
  type        = string
  default     = "1000m"
}

variable "memory_limit_traces" {
  description = "Memory limit for Traces collector"
  type        = string
  default     = "2Gi"
}

variable "cpu_request_traces" {
  description = "CPU request for Traces collector"
  type        = string
  default     = "500m"
}

variable "memory_request_traces" {
  description = "Memory request for Traces collector"
  type        = string
  default     = "1Gi"
}

# Resource limits and requests for Metrics collector
variable "cpu_limit_metrics" {
  description = "CPU limit for Metrics collector"
  type        = string
  default     = "1000m"
}

variable "memory_limit_metrics" {
  description = "Memory limit for Metrics collector"
  type        = string
  default     = "2Gi"
}

variable "cpu_request_metrics" {
  description = "CPU request for Metrics collector"
  type        = string
  default     = "500m"
}

variable "memory_request_metrics" {
  description = "Memory request for Metrics collector"
  type        = string
  default     = "1Gi"
}

