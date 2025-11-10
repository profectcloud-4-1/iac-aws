variable "name" {
  description = "리소스 식별자 접두사(서비스명 등)"
  type        = string
}

variable "engine_version" {
  description = "PostgreSQL 엔진 버전"
  type        = string
  default     = "16.10"
}

variable "instance_class" {
  description = "RDS 인스턴스 클래스"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "초기 데이터베이스 이름"
  type        = string
  default     = null
}

variable "username" {
  description = "마스터 사용자명"
  type        = string
  sensitive   = true
}

variable "password" {
  description = "마스터 사용자 비밀번호"
  type        = string
  sensitive   = true
}

variable "allocated_storage" {
  description = "스토리지(GB)"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "스토리지 타입 (gp3 권장)"
  type        = string
  default     = "gp3"
}

variable "multi_az" {
  description = "Multi-AZ 배포 사용 여부"
  type        = bool
  default     = false
}

variable "availability_zone" {
  description = "단일 AZ 배치를 위한 가용영역"
  type        = string
  default     = "ap-northeast-2a"
}

variable "subnet_ids" {
  description = "DB Subnet Group에 포함할 서브넷 ID 목록(서로 다른 AZ 권장)"
  type        = list(string)
}

variable "vpc_id" {
  description = "보안그룹 생성을 위한 VPC ID"
  type        = string
}

variable "create_security_group" {
  description = "내부에서 전용 RDS SG를 생성할지 여부"
  type        = bool
  default     = true
}

variable "security_group_ids" {
  description = "외부에서 전달받을 SG ID 목록(설정 시 내부 SG 생성 비활성화 권장)"
  type        = list(string)
  default     = []
}
variable "apply_immediately" {
  description = "변경 사항 즉시 적용 여부"
  type        = bool
  default     = true
}

