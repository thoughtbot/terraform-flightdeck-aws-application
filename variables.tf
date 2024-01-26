variable "execution_role_arns" {
  description = "ARNs of execution roles allowed to manage this application"
  type        = list(string)
  default     = []
}

variable "execution_role_names" {
  description = "Names of execution roles allowed to manage this application"
  type        = list(string)
  default     = ["terraform-execution"]
}

variable "name" {
  description = "Name of this application"
  type        = string
}

variable "cluster_names" {
  description = "Names of EKS clusters for application"
  type        = list(string)
}

variable "service_account_name" {
  description = "Name of the Kubernetes service account for the application"
  type        = string
  default     = null
}

variable "stage" {
  description = "Software development lifecycle stage for this tenant"
  type        = string
}
