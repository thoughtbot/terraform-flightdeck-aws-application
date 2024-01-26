variable "sentry_enabled" {
  description = "Set to true to enable creation of a Sentry DSN"
  type        = bool
  default     = false
}

variable "sentry_project" {
  description = "Slug of the Sentry project"
  type        = string
  default     = null
}

variable "sentry_organization" {
  description = "Slug of the Sentry organization"
  type        = string
  default     = null
}
