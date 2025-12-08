variable "cluster_name" {
  description = "MSK 클러스터 이름"
  type        = string
  default     = "goorm-msk"
}

variable "subnet_ids" {
  description = "MSK 브로커를 배치할 서브넷 ID 목록(3개, AZ별)"
  type        = list(string)
}

variable "vpc_id" {
  description = "보안 그룹 생성을 위한 VPC ID"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR 블록(보안 그룹 기본 허용대역에 사용)"
  type        = string
}

variable "security_group_ids" {
  description = "MSK 브로커에 추가로 부착할 보안그룹 리스트"
  type        = list(string)
}

variable "broker_count" {
  description = "브로커 개수"
  type        = number
  default     = 3
}

variable "ebs_volume_size" {
  description = "브로커 EBS 용량(GB)"
  type        = number
  default     = 20
}

variable "instance_type" {
  description = "브로커 인스턴스 타입"
  type        = string
  default     = "kafka.t3.small"
}

variable "kafka_version" {
  description = "Kafka 버전 (예: 3.8.x). 주키퍼 기반 클러스터는 일부 버전만 지원됩니다."
  type        = string
  default     = "3.8.x"
}

variable "allow_everyone_if_no_acl_found" {
  description = "allow.everyone.if.no.acl.found 설정값"
  type        = bool
  default     = false
}

variable "scram_secret_arns" {
  description = "SCRAM 사용자 시크릿 ARNs (Secrets Manager). 비어있으면 연동 생략"
  type        = list(string)
  default     = []
}

variable "aws_region" {
  description = "AWS region to deploy MSK subnets"
  type        = string
  default     = "ap-northeast-2"
}

variable "enhanced_monitoring" {
  description = "MSK 클러스터 모니터링 수준 (DEFAULT | PER_BROKER | PER_TOPIC_PER_BROKER | PER_TOPIC_PER_PARTITION)"
  type        = string
  default     = "PER_TOPIC_PER_BROKER"
}

variable "enable_broker_logs_cloudwatch" {
  description = "브로커 로그를 CloudWatch Logs로 전송 여부"
  type        = bool
  default     = true
}

variable "broker_logs_cloudwatch_log_group" {
  description = "브로커 로그를 보낼 CloudWatch Log Group 이름 (enable=true 시 지정 권장)"
  type        = string
  default     = "/aws/msk/goorm/cluster"
}
