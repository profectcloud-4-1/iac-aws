variable "external_secrets_operator_role_arn" {
  description = "External Secrets Operator(IRSA) 역할 ARN"
  type        = string
}

variable "namespace" {
  description = "External Secrets Operator 네임스페이스"
  type        = string
  default     = "external-secrets"
}