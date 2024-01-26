output "service_account_name" {
  description = "Name of the Kubernetes service account"
  value       = local.service_account_name
}

output "pod_role_arn" {
  description = "ARN of the IAM role for Kubernetes pods"
  value       = module.pod_role.arn
}

output "namespace" {
  description = "Kubernetes namespace to which this application deploys"
  value       = local.instance_name
}
