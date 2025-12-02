variable "namespace" {
  description = "Grafana가 배포될 네임스페이스"
  type        = string
  default     = "observability"
}

variable "admin_password" {
  description = "Grafana 관리자(admin) 비밀번호"
  type        = string
  default     = "1234"
  sensitive   = true
}

variable "chart_version" {
  description = "Grafana Helm 차트 버전(빈 값이면 최신)"
  type        = string
  default     = ""
}

variable "loki_host" {
  description = "Loki 서비스 호스트 (FQDN, 포트 제외)"
  type        = string
}

variable "tempo_host" {
  description = "Tempo 서비스 호스트 (FQDN, 포트 제외)"
  type        = string
}

variable "mimir_host" {
  description = "Mimir 게이트웨이/NGINX 서비스 호스트 (FQDN, 포트 제외)"
  type        = string
}

variable "loki_port" {
  description = "Loki 서비스 포트"
  type        = number
  default     = 3100
}

variable "tempo_port" {
  description = "Tempo Query Frontend 포트"
  type        = number
  default     = 3100
}

variable "mimir_port" {
  description = "Mimir NGINX 포트"
  type        = number
  default     = 80
}

variable "mimir_path" {
  description = "Grafana Prometheus datasource에 사용할 Mimir 경로"
  type        = string
  default     = "/prometheus"
}

variable "alb_annotations" {
  description = "ALB Ingress에 적용할 추가 주석"
  type        = map(string)
  default     = {}
}

