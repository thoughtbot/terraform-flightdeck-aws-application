variable "s3_bucket_name" {
  description = "Name of the S3 bucket for this application"
  type        = string
  default     = null
}

variable "s3_enabled" {
  description = "Set to true to enable creation of an S3 bucket"
  type        = bool
  default     = false
}

variable "s3_read_principals" {
  description = "Additional principals able to read S3 data"
  type        = list(string)
  default     = []
}

variable "s3_readwrite_principals" {
  description = "Additional principals able to read and write S3 data"
  type        = list(string)
  default     = []
}
