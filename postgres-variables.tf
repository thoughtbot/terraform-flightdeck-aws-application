variable "postgres_admin_username" {
  description = "Username for the admin user"
  default     = "postgres"
  type        = string
}

variable "postgres_allocated_storage" {
  description = "Size in GB for the database instance"
  type        = number
  default     = null
}

variable "postgres_apply_immediately" {
  description = "Set to true to immediately apply changes and cause downtime"
  type        = bool
  default     = false
}

variable "postgres_default_database" {
  description = "Name of the default database"
  type        = string
  default     = "postgres"
}

variable "postgres_enabled" {
  description = "Set to true to enable creation of the Postgres database"
  type        = bool
  default     = false
}

variable "postgres_engine_version" {
  description = "Version for RDS database engine"
  type        = string
  default     = null
}

variable "postgres_identifier" {
  description = "Unique identifier for this database"
  type        = string
  default     = null
}

variable "postgres_instance_class" {
  description = "Tier for the database instance"
  type        = string
  default     = null
}

variable "postgres_max_allocated_storage" {
  description = "Maximum size GB after autoscaling"
  type        = number
  default     = null
}

variable "postgres_storage_encrypted" {
  description = "Set to false to disable encryption at rest"
  type        = bool
  default     = true
}
