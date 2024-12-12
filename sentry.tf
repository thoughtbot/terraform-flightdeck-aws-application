module "sentry_dsn" {
  count  = var.sentry_enabled ? 1 : 0
  source = "github.com/thoughtbot/terraform-aws-sentry-dsn?ref=v0.4.0"

  name              = var.sentry_project
  organization_slug = var.sentry_organization
  project_slug      = var.sentry_project
  subnet_ids        = module.network.private_subnet_ids
  vpc_id            = module.network.vpc.id
  read_principals   = local.read_principals
}
