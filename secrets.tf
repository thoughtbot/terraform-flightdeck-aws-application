module "secret_key" {
  source = "github.com/thoughtbot/terraform-aws-secrets//random-secret?ref=v0.6.0"

  description           = "Secret key for ${local.instance_name}"
  environment_variables = [var.secret_key_variable]
  name                  = "${local.instance_name}-secret-key"
}

module "developer_managed_secrets" {
  for_each = var.developer_managed_secrets

  source = "github.com/thoughtbot/terraform-aws-secrets//user-managed-secret?ref=v0.5.0"

  description           = "Developer-managed ${each.key} secrets for ${local.instance_name}"
  environment_variables = each.value
  name                  = "${local.instance_name}-${lower(each.key)}"
  read_principals       = local.read_principals
  readwrite_principals  = local.readwrite_principals
}

module "secrets_policy" {
  source = "github.com/thoughtbot/terraform-aws-secrets//read-secret-policy?ref=v0.6.0"

  policy_name  = "${local.instance_name}-secrets"
  role_names   = [module.pod_role.name]
  secret_names = local.secrets.*.secret_name

  depends_on = [
    module.postgres_admin_login,
    module.redis_token,
    module.secret_key_base,
    module.user_managed_secrets,
  ]
}

