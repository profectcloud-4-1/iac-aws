variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.9.0.0/16"
}

variable "prevent_destroy" {
  description = "Prevent destroy"
  type        = bool
  default     = false
}