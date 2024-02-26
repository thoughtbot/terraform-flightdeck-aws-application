output "developer_managed_secrets" {
  description = "SecretsManager environment variables managed by developers"
  value = [
    for secret in values(module.developer_managed_secrets) :
    {
      name                  = secret.secret_name
      environment_variables = secret.environment_variables
    }
  ]
}

output "secrets_manager_secrets" {
  description = "SecretsManager environment variables"
  value = [
    for secret in local.secrets :
    {
      name                  = secret.secret_name
      environment_variables = secret.environment_variables
    }
  ]
}
