variable "deploy_role_name" {
  description = "Override the name of the deploy role"
  type        = string
  default     = null
}

variable "github_branches" {
  description = "GitHub branches allowed to deploy to this instance"
  type        = list(string)
}

variable "github_iam_oidc_provider_arn" {
  description = "ARN for the GitHub Actions IAM OIDC provider"
  type        = string
}

variable "github_organization" {
  description = "GitHub organization allowed to deploy to this instance"
  type        = string
}

variable "github_repository" {
  description = "GitHub repository allowed to deploy to this instance"
  type        = string
}
