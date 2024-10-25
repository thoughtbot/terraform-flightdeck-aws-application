variable "es_application_name" {
  type        = string
  description = "Unique name for the opensearch instance"
  default     = ""
}

variable "es_instance_count" {
  type        = number
  description = "Number of instances in the cluster"
  default     = 1
}

variable "es_dedicated_master_type" {
  type        = string
  description = "Instance type of the dedicated main nodes in the cluster."
}

variable "es_instance_type" {
  type        = string
  description = "Instance type of data nodes in the cluster."
  default     = ""
}

variable "es_volume_type" {
  type        = string
  description = "Type of EBS volumes attached to data nodes."
  default     = "gp3"
}

variable "es_volume_size" {
  type        = number
  description = "Size of EBS volumes attached to data nodes (in GiB)."
  default     = 100
}

variable "es_ebs_iops" {
  type        = number
  description = "Baseline input/output (I/O) performance of EBS volumes attached to data nodes"
  default     = 1000
}

variable "es_engine_version" {
  type        = string
  description = "Version of Elasticsearch to deploy."
}

variable "admin_principals" {
  description = "Principals allowed to peform admin actions (default: current account)"
  type        = list(string)
  default     = null
}

variable "read_principals" {
  description = "Principals allowed to read the secret (default: current account)"
  type        = list(string)
  default     = null
}

variable "elasticsearch_enabled" {
  description = "Set to true to enable creation of the Elasticsearch database"
  type        = bool
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the instance in AWS"
  default     = {}
}
