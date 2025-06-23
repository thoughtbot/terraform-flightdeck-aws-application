variable "redis_enabled" {
  description = "Set to true to enable creation of a Redis instance"
  type        = bool
  default     = false
}

variable "redis_engine_version" {
  description = "The version of redis to run"
  type        = string
  default     = "7.x"
}

variable "redis_enable_kms" {
  description = "Enable KMS encryption"
  type        = bool
  default     = true
}

variable "redis_name" {
  description = "Name of the ElastiCache instance for Redis"
  type        = string
  default     = null
}

variable "redis_node_type" {
  description = "Node type for the ElastiCache instance for Redis"
  type        = string
  default     = null
}

variable "redis_replica_count" {
  description = "Number of replicas for the Redis cluster"
  type        = number
  default     = null
}
