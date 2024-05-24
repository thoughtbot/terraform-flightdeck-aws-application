module "redis" {
  count  = var.redis_enabled ? 1 : 0
  source = "github.com/thoughtbot/terraform-aws-databases//elasticache-redis/replication-group?ref=v0.4.0"

  allowed_cidr_blocks = [module.network.vpc.cidr_block]
  description         = "Redis cluster for ${local.instance_name} jobs"
  engine_version      = "6.x"
  name                = var.redis_name
  node_type           = var.redis_node_type
  replica_count       = var.redis_replica_count
  subnet_ids          = module.network.private_subnet_ids
  vpc_id              = module.network.vpc.id
}

module "redis_token" {
  count  = var.redis_enabled ? 1 : 0
  source = "github.com/thoughtbot/terraform-aws-databases//elasticache-redis/auth-token?ref=v0.4.0"

  initial_auth_token   = module.redis[count.index].initial_auth_token
  replication_group_id = module.redis[count.index].id
  subnet_ids           = module.network.private_subnet_ids
  vpc_id               = module.network.vpc.id

  depends_on = [module.redis]
}

module "redis_policy" {
  count  = var.redis_enabled ? 1 : 0
  source = "github.com/thoughtbot/terraform-aws-secrets//read-secret-policy?ref=v0.6.0"

  policy_name  = "${local.instance_name}-redis"
  role_names   = [module.pod_role.name]
  secret_names = [module.redis_token[count.index].secret_name]

  depends_on = [module.redis_token]
}
