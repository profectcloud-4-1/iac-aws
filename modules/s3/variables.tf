variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "versioning" {
  description = "Enable versioning"
  type        = bool
  default     = false
}

