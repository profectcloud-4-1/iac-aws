variable "namespace" {
  description = "텔레메트리 백엔드가 배포될 네임스페이스"
  type        = string
  default     = "observability"
}

variable "aws_region" {
  description = "S3가 위치한 AWS 리전"
  type        = string
}

variable "s3_bucket_loki" {
  description = "Loki가 사용할 S3 버킷 이름"
  type        = string
  default     = "goormdotcom-log"
}

variable "s3_bucket_tempo" {
  description = "Tempo가 사용할 S3 버킷 이름"
  type        = string
  default     = "goormdotcom-trace"
}

variable "s3_bucket_mimir" {
  description = "Mimir가 사용할 S3 버킷 이름"
  type        = string
  default     = "goormdotcom-metric"
}

variable "s3_force_path_style" {
  description = "S3 path-style 접근 여부"
  type        = bool
  default     = true
}

variable "s3_endpoint" {
  description = "커스텀 S3 엔드포인트 (일반 AWS S3 사용 시 빈 문자열)"
  type        = string
  default     = ""
}

variable "loki_s3_role_arn" {
  description = "Loki S3(IRSA) 역할 ARN"
  type        = string
}

variable "tempo_s3_role_arn" {
  description = "Tempo S3(IRSA) 역할 ARN"
  type        = string
}

variable "mimir_s3_role_arn" {
  description = "Mimir S3(IRSA) 역할 ARN"
  type        = string
}

variable "loki_chart_version" {
  description = "Grafana Loki 차트 버전 (빈 값이면 최신)"
  type        = string
  default     = "6.46.0" # APP 3.5.7
}

variable "tempo_chart_version" {
  description = "Grafana Tempo 차트 버전 (빈 값이면 최신)"
  type        = string
  default     = "1.24.1" # APP 2.9.0
}
