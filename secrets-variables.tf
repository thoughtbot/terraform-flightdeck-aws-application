variable "developer_managed_secrets" {
  description = "Secrets managed manually by developers"
  type        = map(list(string))
  default     = {}
}

variable "generate_secret_key" {
  description = "Set to true to generate a secret key for the application"
  type        = bool
  default     = false
}

variable "secret_key_variable" {
  description = "Name of the environment variable for the application secret key"
  type        = string
  default     = "SECRET_KEY_BASE"
}
