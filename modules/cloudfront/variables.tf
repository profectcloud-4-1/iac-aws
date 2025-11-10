variable "domain_name" {
  description = "CloudFront 도메인(예: api.goorm.store)"
  type        = string
}

variable "hosted_zone_name" {
  description = "Route53 HostedZone 도메인(예: goorm.store)"
  type        = string
}

variable "user_api_endpoint" {
  description = "User API Gateway 엔드포인트(https://... 형태)"
  type        = string
}

variable "product_api_endpoint" {
  description = "Product API Gateway 엔드포인트(https://... 형태)"
  type        = string
}

variable "order_api_endpoint" {
  description = "Order API Gateway 엔드포인트(https://... 형태)"
  type        = string
}

variable "payment_api_endpoint" {
  description = "Payment API Gateway 엔드포인트(https://... 형태)"
  type        = string
}

