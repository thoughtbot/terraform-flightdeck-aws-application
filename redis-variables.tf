variable "redis_enabled" {
  description = "Set to true to enable creation of a Redis instance"
  type        = bool
  default     = false
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
