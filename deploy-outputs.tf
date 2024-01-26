output "deploy_role_arn" {
  description = "ARN of the IAM role for deploying to this Kubernetes namespace"
  value       = module.deploy_role.arn
}

output "deploy_role_name" {
  description = "Name of the IAM role for deploying to this Kubernetes namespace"
  value       = module.deploy_role.name
}
