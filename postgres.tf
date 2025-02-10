module "postgres" {
  count  = var.postgres_enabled ? 1 : 0
  source = "github.com/thoughtbot/terraform-aws-databases//rds-postgres/primary-instance?ref=v0.6.1"

  admin_username           = var.postgres_admin_username
  allocated_storage        = var.postgres_allocated_storage
  allowed_cidr_blocks      = [module.network.vpc.cidr_block]
  apply_immediately        = var.postgres_apply_immediately
  create_cloudwatch_alarms = false
  default_database         = var.postgres_default_database
  engine_version           = var.postgres_engine_version
  identifier               = var.postgres_identifier
  instance_class           = var.postgres_instance_class
  max_allocated_storage    = var.postgres_max_allocated_storage
  parameter_group_name     = "${var.postgres_identifier}-${random_id.parameter_group.hex}"
  storage_encrypted        = var.postgres_storage_encrypted
  subnet_ids               = module.network.private_subnet_ids
  vpc_id                   = module.network.vpc.id
  enable_kms               = var.postgres_enable_kms
}

resource "random_id" "parameter_group" {
  keepers = {
    engine_version = var.postgres_engine_version
  }

  byte_length = 8
}

module "postgres_admin_login" {
  count  = var.postgres_enabled ? 1 : 0
  source = "github.com/thoughtbot/terraform-aws-databases//rds-postgres/admin-login?ref=v0.6.1"

  database_name    = module.postgres[count.index].default_database
  identifier       = module.postgres[count.index].identifier
  initial_password = module.postgres[count.index].initial_password
  read_principals  = local.read_principals
  subnet_ids       = module.network.private_subnet_ids
  username         = module.postgres[count.index].admin_username
  vpc_id           = module.network.vpc.id

  depends_on = [module.postgres]
}

module "postgres_policy" {
  count  = var.postgres_enabled ? 1 : 0
  source = "github.com/thoughtbot/terraform-aws-secrets//read-secret-policy?ref=v0.8.0"

  policy_name  = "${local.instance_name}-postgres"
  role_names   = [module.pod_role.name]
  secret_names = [module.postgres_admin_login[count.index].secret_name]

  depends_on = [module.postgres_admin_login]
}
