module "secret_key" {
  count  = var.generate_secret_key ? 1 : 0
  source = "github.com/thoughtbot/terraform-aws-secrets//random-secret?ref=v0.6.0"

  description           = "Secret key for ${local.instance_name}"
  environment_variables = [var.secret_key_variable]
  name                  = "${local.instance_name}-secret-key"
}

module "secret_key_policy" {
  count  = var.generate_secret_key ? 1 : 0
  source = "github.com/thoughtbot/terraform-aws-secrets//read-secret-policy?ref=v0.6.0"

  policy_name  = "${local.instance_name}-secret-key"
  role_names   = [module.pod_role.name]
  secret_names = [module.developer_managed_secrets[count.index].secret_name]
}

module "developer_managed_secrets" {
  for_each = var.developer_managed_secrets

  source = "github.com/thoughtbot/terraform-aws-secrets//user-managed-secret?ref=v0.5.0"

  description           = "Developer-managed ${each.key} secrets for ${local.instance_name}"
  environment_variables = each.value
  name                  = "${local.instance_name}-${lower(each.key)}"
  read_principals       = local.secret_principals
  readwrite_principals  = local.secret_principals
}

module "developer_managed_secrets_policy" {
  source = "github.com/thoughtbot/terraform-aws-secrets//read-secret-policy?ref=v0.6.0"

  policy_name  = "${local.instance_name}-managed-secrets"
  role_names   = [module.pod_role.name]
  secret_names = values(module.developer_managed_secrets)[*].secret_name

  depends_on = [module.developer_managed_secrets]
}
