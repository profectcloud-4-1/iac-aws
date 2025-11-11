variable "name" {
  description = "NLB 이름"
  type        = string
  default     = "goorm-nlb"
}

variable "subnet_ids" {
  description = "NLB가 배치될 서브넷 ID 목록"
  type        = list(string)
}

variable "internal" {
  description = "내부 NLB 여부(true=internal)"
  type        = bool
  default     = true
}

variable "enable_cross_zone_load_balancing" {
  description = "가용영역 간 로드밸런싱 활성화"
  type        = bool
  default     = false
}

variable "target_group_arns_map" {
  description = "대상그룹 이름 => ARN 맵 (tg-user-1/2, tg-product-1/2, tg-order-1/2, tg-payment-1/2)"
  type        = map(string)
}

variable "prevent_destroy" {
  description = "Prevent destroy"
  type        = bool
  default     = false
}
