module "sso_roles" {
  source = "github.com/thoughtbot/terraform-aws-sso-permission-set-roles?ref=v0.2.0"
}

module "pod_role" {
  source = "github.com/thoughtbot/flightdeck//aws/service-account-role?ref=v0.9.0"

  cluster_names    = var.cluster_names
  name             = "${local.instance_name}-pods"
  service_accounts = ["${local.instance_name}:${local.service_account_name}"]
}

module "pod_policy" {
  source = "github.com/thoughtbot/flightdeck//aws/service-account-policy?ref=v0.9.0"

  name             = "${local.instance_name}-pods"
  policy_documents = module.s3_bucket[*].policy_json
  role_names       = [module.pod_role.name]
}

module "cluster" {
  source = "github.com/thoughtbot/flightdeck//aws/cluster-name?ref=v0.9.0"

  name = var.cluster_names[0]
}

module "network" {
  source = "github.com/thoughtbot/flightdeck//aws/network-data?ref=v0.9.0"

  tags = module.cluster.shared_tags
}


locals {
  execution_role_arns  = concat(var.execution_role_arns, values(data.aws_iam_role.execution)[*].arn)
  instance_name        = "${var.name}-${var.stage}"
  service_account_name = coalesce(var.service_account_name, var.name)

  read_principals = concat(
    local.execution_role_arns,
    [
      module.sso_roles.by_name.InfrastructureAdmin,
      module.sso_roles.by_name.SecretsAccess,
      module.pod_role.arn,
    ]
  )

  readwrite_principals = concat(
    local.execution_role_arns,
    [
      module.sso_roles.by_name.InfrastructureAdmin,
      module.sso_roles.by_name.SecretsAccess,
    ]
  )

  secrets = concat(
    module.postgres_admin_login[*],
    module.redis_token[*],
    [module.secret_key_base],
    values(module.user_managed_secrets),
  )
}

data "aws_iam_role" "execution" {
  for_each = toset(var.execution_role_names)

  name = each.value
}
