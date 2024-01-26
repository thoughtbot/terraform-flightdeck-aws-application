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
