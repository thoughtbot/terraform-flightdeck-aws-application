# Flightdeck AWS Application

This Terraform module provisions AWS resources for running an application on
[Flightdeck].

[Flightdeck]: https://github.com/thoughtbot/flightdeck

## Example

```
module "production" {
  source = "git@github.com:thoughtbot/terraform-flightdeck-aws-application.git?ref=v0.1.0"

  # Required
  cluster_names = ["example-production-v1"]
  name          = "example"
  stage         = "production"

  # Generate a secret key
  generate_secret_key = true
  secret_key_variable = "SECRET_KEY_BASE"

  # Postgres
  postgres_enabled               = true
  postgres_allocated_storage     = 64
  postgres_engine_version        = "14.8"
  postgres_identifier            = "example-red"
  postgres_instance_class        = "db.t4g.large"
  postgres_max_allocated_storage = 128

  # Redis
  redis_enabled        = true
  redis_name           = "example-production-blue"
  redis_node_type      = "cache.m6g.large"
  redis_replica_count  = 1
  redis_engine_version = "7.x"

  # S3
  s3_enabled     = true
  s3_bucket_name = "example-uploads"

  # Sentry DSN
  sentry_enabled      = true
  sentry_organization = "myorg"
  sentry_project      = "example"

  # Developer managed secrets
  developer_managed_secrets = {
    Email = ["SMTP_USERNAME", "SMTP_PASSWORD"]
  }

  # AWS IAM Identity Center permissions
  readwrite_permission_sets = ["DeveloperAccess"]
  secret_permission_sets    = ["SecretsAccess"]
}
```

This module is designed as a quick start to cover the most common cases for
applications running on Flightdeck. If you need additional resources for your
application or want to customize further than the variables allow, you can clone
this module into a directory in your Terraform project and use a local module
reference.

This module can be combined with the [application-config module] to quickly
create necessary base resources in the target cluster:

```
module "production_v1" {
  source    = "github.com/thoughtbot/flightdeck//aws/application-config?ref=v0.10.0"
  providers = { kubernetes = kubernetes.production_v1 }

  developer_group         = "developer"
  enable_exec             = true
  namespace               = module.production.namespace
  secrets_manager_secrets = module.production.secrets_manager_secrets
  pod_service_account     = module.production.service_account_name
  pod_iam_role            = module.production.pod_role_arn

  depends_on = [module.production]
}
```

[application-config module]: https://github.com/thoughtbot/flightdeck/tree/main/aws/application-config

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cluster"></a> [cluster](#module\_cluster) | github.com/thoughtbot/flightdeck//aws/cluster-name | v0.12.1 |
| <a name="module_deploy_role"></a> [deploy\_role](#module\_deploy\_role) | github.com/thoughtbot/terraform-eks-cicd//modules/github-actions-eks-deploy-role | v0.3.0 |
| <a name="module_developer_managed_secrets"></a> [developer\_managed\_secrets](#module\_developer\_managed\_secrets) | github.com/thoughtbot/terraform-aws-secrets//user-managed-secret | v0.8.0 |
| <a name="module_developer_managed_secrets_policy"></a> [developer\_managed\_secrets\_policy](#module\_developer\_managed\_secrets\_policy) | github.com/thoughtbot/terraform-aws-secrets//read-secret-policy | v0.8.0 |
| <a name="module_es_pod_policy"></a> [es\_pod\_policy](#module\_es\_pod\_policy) | github.com/thoughtbot/flightdeck//aws/service-account-policy | v0.12.1 |
| <a name="module_network"></a> [network](#module\_network) | github.com/thoughtbot/flightdeck//aws/network-data | v0.12.1 |
| <a name="module_opensearch"></a> [opensearch](#module\_opensearch) | ./modules/opensearch | n/a |
| <a name="module_pod_policy"></a> [pod\_policy](#module\_pod\_policy) | github.com/thoughtbot/flightdeck//aws/service-account-policy | v0.12.1 |
| <a name="module_pod_role"></a> [pod\_role](#module\_pod\_role) | github.com/thoughtbot/flightdeck//aws/service-account-role | v0.12.1 |
| <a name="module_postgres"></a> [postgres](#module\_postgres) | github.com/thoughtbot/terraform-aws-databases//rds-postgres/primary-instance | v0.6.1 |
| <a name="module_postgres_admin_login"></a> [postgres\_admin\_login](#module\_postgres\_admin\_login) | github.com/thoughtbot/terraform-aws-databases//rds-postgres/admin-login | v0.6.1 |
| <a name="module_postgres_policy"></a> [postgres\_policy](#module\_postgres\_policy) | github.com/thoughtbot/terraform-aws-secrets//read-secret-policy | v0.8.0 |
| <a name="module_redis"></a> [redis](#module\_redis) | github.com/thoughtbot/terraform-aws-databases//elasticache-redis/replication-group | v0.6.1 |
| <a name="module_redis_policy"></a> [redis\_policy](#module\_redis\_policy) | github.com/thoughtbot/terraform-aws-secrets//read-secret-policy | v0.8.0 |
| <a name="module_redis_token"></a> [redis\_token](#module\_redis\_token) | github.com/thoughtbot/terraform-aws-databases//elasticache-redis/auth-token | v0.6.1 |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | github.com/thoughtbot/terraform-s3-bucket | v0.4.0 |
| <a name="module_secret_key"></a> [secret\_key](#module\_secret\_key) | github.com/thoughtbot/terraform-aws-secrets//random-secret | v0.8.0 |
| <a name="module_secret_key_policy"></a> [secret\_key\_policy](#module\_secret\_key\_policy) | github.com/thoughtbot/terraform-aws-secrets//read-secret-policy | v0.8.0 |
| <a name="module_sentry_dsn"></a> [sentry\_dsn](#module\_sentry\_dsn) | github.com/thoughtbot/terraform-aws-sentry-dsn | v0.4.0 |
| <a name="module_sso_roles"></a> [sso\_roles](#module\_sso\_roles) | github.com/thoughtbot/terraform-aws-sso-permission-set-roles | v0.3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_service_linked_role.elasticsearch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_service_linked_role) | resource |
| [random_id.parameter_group](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_password.es](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_iam_policy_document.ecs_osis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_role.execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_ssm_parameter.prometheus_workspace_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_names"></a> [cluster\_names](#input\_cluster\_names) | Names of EKS clusters for application | `list(string)` | n/a | yes |
| <a name="input_deploy_role_name"></a> [deploy\_role\_name](#input\_deploy\_role\_name) | Override the name of the deploy role | `string` | `null` | no |
| <a name="input_developer_managed_secrets"></a> [developer\_managed\_secrets](#input\_developer\_managed\_secrets) | Secrets managed manually by developers | `map(list(string))` | `{}` | no |
| <a name="input_elasticsearch_enabled"></a> [elasticsearch\_enabled](#input\_elasticsearch\_enabled) | Set to true to enable creation of the Elasticsearch database | `bool` | `false` | no |
| <a name="input_es_admin_principals"></a> [es\_admin\_principals](#input\_es\_admin\_principals) | Principals allowed to peform admin actions (default: current account) | `list(string)` | `null` | no |
| <a name="input_es_application_name"></a> [es\_application\_name](#input\_es\_application\_name) | Unique name for the opensearch instance | `string` | `""` | no |
| <a name="input_es_dedicated_master_type"></a> [es\_dedicated\_master\_type](#input\_es\_dedicated\_master\_type) | Instance type of the dedicated main nodes in the cluster. | `string` | n/a | yes |
| <a name="input_es_ebs_iops"></a> [es\_ebs\_iops](#input\_es\_ebs\_iops) | Baseline input/output (I/O) performance of EBS volumes attached to data nodes | `number` | `3000` | no |
| <a name="input_es_engine_version"></a> [es\_engine\_version](#input\_es\_engine\_version) | Version of Elasticsearch to deploy. | `string` | n/a | yes |
| <a name="input_es_instance_count"></a> [es\_instance\_count](#input\_es\_instance\_count) | Number of instances in the cluster | `number` | `2` | no |
| <a name="input_es_instance_type"></a> [es\_instance\_type](#input\_es\_instance\_type) | Instance type of data nodes in the cluster. | `string` | `""` | no |
| <a name="input_es_read_principals"></a> [es\_read\_principals](#input\_es\_read\_principals) | Principals allowed to read the secret (default: current account) | `list(string)` | `null` | no |
| <a name="input_es_volume_size"></a> [es\_volume\_size](#input\_es\_volume\_size) | Size of EBS volumes attached to data nodes (in GiB). | `number` | `100` | no |
| <a name="input_es_volume_type"></a> [es\_volume\_type](#input\_es\_volume\_type) | Type of EBS volumes attached to data nodes. | `string` | `"gp3"` | no |
| <a name="input_execution_role_arns"></a> [execution\_role\_arns](#input\_execution\_role\_arns) | ARNs of execution roles allowed to manage this application | `list(string)` | `[]` | no |
| <a name="input_execution_role_names"></a> [execution\_role\_names](#input\_execution\_role\_names) | Names of execution roles allowed to manage this application | `list(string)` | <pre>[<br>  "terraform-execution"<br>]</pre> | no |
| <a name="input_generate_secret_key"></a> [generate\_secret\_key](#input\_generate\_secret\_key) | Set to true to generate a secret key for the application | `bool` | `false` | no |
| <a name="input_github_branches"></a> [github\_branches](#input\_github\_branches) | GitHub branches allowed to deploy to this instance | `list(string)` | n/a | yes |
| <a name="input_github_iam_oidc_provider_arn"></a> [github\_iam\_oidc\_provider\_arn](#input\_github\_iam\_oidc\_provider\_arn) | ARN for the GitHub Actions IAM OIDC provider | `string` | n/a | yes |
| <a name="input_github_organization"></a> [github\_organization](#input\_github\_organization) | GitHub organization allowed to deploy to this instance | `string` | n/a | yes |
| <a name="input_github_repository"></a> [github\_repository](#input\_github\_repository) | GitHub repository allowed to deploy to this instance | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of this application | `string` | n/a | yes |
| <a name="input_postgres_admin_username"></a> [postgres\_admin\_username](#input\_postgres\_admin\_username) | Username for the admin user | `string` | `"postgres"` | no |
| <a name="input_postgres_allocated_storage"></a> [postgres\_allocated\_storage](#input\_postgres\_allocated\_storage) | Size in GB for the database instance | `number` | `null` | no |
| <a name="input_postgres_apply_immediately"></a> [postgres\_apply\_immediately](#input\_postgres\_apply\_immediately) | Set to true to immediately apply changes and cause downtime | `bool` | `false` | no |
| <a name="input_postgres_default_database"></a> [postgres\_default\_database](#input\_postgres\_default\_database) | Name of the default database | `string` | `"postgres"` | no |
| <a name="input_postgres_enabled"></a> [postgres\_enabled](#input\_postgres\_enabled) | Set to true to enable creation of the Postgres database | `bool` | `false` | no |
| <a name="input_postgres_engine_version"></a> [postgres\_engine\_version](#input\_postgres\_engine\_version) | Version for RDS database engine | `string` | `null` | no |
| <a name="input_postgres_identifier"></a> [postgres\_identifier](#input\_postgres\_identifier) | Unique identifier for this database | `string` | `null` | no |
| <a name="input_postgres_instance_class"></a> [postgres\_instance\_class](#input\_postgres\_instance\_class) | Tier for the database instance | `string` | `null` | no |
| <a name="input_postgres_max_allocated_storage"></a> [postgres\_max\_allocated\_storage](#input\_postgres\_max\_allocated\_storage) | Maximum size GB after autoscaling | `number` | `null` | no |
| <a name="input_postgres_storage_encrypted"></a> [postgres\_storage\_encrypted](#input\_postgres\_storage\_encrypted) | Set to false to disable encryption at rest | `bool` | `true` | no |
| <a name="input_prometheus_workspace_name"></a> [prometheus\_workspace\_name](#input\_prometheus\_workspace\_name) | Name of the AMP workspace to which metrics will be written | `string` | `null` | no |
| <a name="input_read_permission_sets"></a> [read\_permission\_sets](#input\_read\_permission\_sets) | AWS IAM permission sets allowed to read application data | `list(string)` | `[]` | no |
| <a name="input_readwrite_permission_sets"></a> [readwrite\_permission\_sets](#input\_readwrite\_permission\_sets) | AWS IAM permission sets allowed to read and write application data | `list(string)` | `[]` | no |
| <a name="input_redis_enabled"></a> [redis\_enabled](#input\_redis\_enabled) | Set to true to enable creation of a Redis instance | `bool` | `false` | no |
| <a name="input_redis_name"></a> [redis\_name](#input\_redis\_name) | Name of the ElastiCache instance for Redis | `string` | `null` | no |
| <a name="input_redis_node_type"></a> [redis\_node\_type](#input\_redis\_node\_type) | Node type for the ElastiCache instance for Redis | `string` | `null` | no |
| <a name="input_redis_replica_count"></a> [redis\_replica\_count](#input\_redis\_replica\_count) | Number of replicas for the Redis cluster | `number` | `null` | no |
| <a name="input_redis_engine_version"></a> [redis\ engine\ version](#input\_redis\_engine\_version) | ElastiCache instance Redis version| `string` | `null` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | Name of the S3 bucket for this application | `string` | `null` | no |
| <a name="input_s3_enabled"></a> [s3\_enabled](#input\_s3\_enabled) | Set to true to enable creation of an S3 bucket | `bool` | `false` | no |
| <a name="input_s3_read_principals"></a> [s3\_read\_principals](#input\_s3\_read\_principals) | Additional principals able to read S3 data | `list(string)` | `[]` | no |
| <a name="input_s3_readwrite_principals"></a> [s3\_readwrite\_principals](#input\_s3\_readwrite\_principals) | Additional principals able to read and write S3 data | `list(string)` | `[]` | no |
| <a name="input_secret_key_variable"></a> [secret\_key\_variable](#input\_secret\_key\_variable) | Name of the environment variable for the application secret key | `string` | `"SECRET_KEY_BASE"` | no |
| <a name="input_secret_permission_sets"></a> [secret\_permission\_sets](#input\_secret\_permission\_sets) | AWS IAM permission sets allow to read and manage secrets | `list(string)` | `[]` | no |
| <a name="input_sentry_enabled"></a> [sentry\_enabled](#input\_sentry\_enabled) | Set to true to enable creation of a Sentry DSN | `bool` | `false` | no |
| <a name="input_sentry_organization"></a> [sentry\_organization](#input\_sentry\_organization) | Slug of the Sentry organization | `string` | `null` | no |
| <a name="input_sentry_project"></a> [sentry\_project](#input\_sentry\_project) | Slug of the Sentry project | `string` | `null` | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Name of the Kubernetes service account for the application | `string` | `null` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | Software development lifecycle stage for this tenant | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the instance in AWS | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_deploy_role_arn"></a> [deploy\_role\_arn](#output\_deploy\_role\_arn) | ARN of the IAM role for deploying to this Kubernetes namespace |
| <a name="output_deploy_role_name"></a> [deploy\_role\_name](#output\_deploy\_role\_name) | Name of the IAM role for deploying to this Kubernetes namespace |
| <a name="output_developer_managed_secrets"></a> [developer\_managed\_secrets](#output\_developer\_managed\_secrets) | SecretsManager environment variables managed by developers |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | Kubernetes namespace to which this application deploys |
| <a name="output_pod_role_arn"></a> [pod\_role\_arn](#output\_pod\_role\_arn) | ARN of the IAM role for Kubernetes pods |
| <a name="output_secrets_manager_secrets"></a> [secrets\_manager\_secrets](#output\_secrets\_manager\_secrets) | SecretsManager environment variables |
| <a name="output_service_account_name"></a> [service\_account\_name](#output\_service\_account\_name) | Name of the Kubernetes service account |
<!-- END_TF_DOCS -->

## Contributing

Please see [CONTRIBUTING.md](./CONTRIBUTING.md).

## License

This module is Copyright © 2024 Joe Ferris and thoughtbot. It is free
software, and may be redistributed under the terms specified in the [LICENSE]
file.

[LICENSE]: ./LICENSE

<!-- START /templates/footer.md -->
## About thoughtbot

![thoughtbot](https://thoughtbot.com/thoughtbot-logo-for-readmes.svg)

This repo is maintained and funded by thoughtbot, inc.
The names and logos for thoughtbot are trademarks of thoughtbot, inc.

We love open source software!
See [our other projects][community].
We are [available for hire][hire].

[community]: https://thoughtbot.com/community?utm_source=github
[hire]: https://thoughtbot.com/hire-us?utm_source=github


<!-- END /templates/footer.md -->
