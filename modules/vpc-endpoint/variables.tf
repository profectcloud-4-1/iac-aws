variable "name_prefix" {
  description = "VPC endpoint prefix"
  type        = string
}

variable "vpc_id" {
  description = "endpoint가 만들어지는 VPC ID"
  type        = string
}

variable "region" {
  description = "엔드포인트 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "private_subnet_ids" {
  description = "인터페이스 엔드포인트 붙일 프라이빗 서브넷 id"
  type        = list(string)
}

variable "route_table_ids" {
  description = "Gateway Endpoint 넣을 route table id"
  type        = list(string)
}

variable "vpce_sg_id" {
  description = "Security group ID for Interface Endpoints"
  type        = string
}