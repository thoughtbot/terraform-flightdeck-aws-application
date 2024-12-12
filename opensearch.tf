data "aws_availability_zones" "available" {}

locals {
  region             = data.aws_region.current.name
  name               = "es-${var.es_application_name}"
  ideal_subnet_count = var.es_instance_count > 2 ? min(length(module.network.private_subnet_ids), 3) : var.es_instance_count
}

resource "aws_iam_service_linked_role" "elasticsearch" {
  count            = var.elasticsearch_enabled ? 1 : 0
  aws_service_name = "es.amazonaws.com"
}

################################################################################
# OpenSearch Module
################################################################################

module "opensearch" {
  count  = var.elasticsearch_enabled ? 1 : 0
  source = "./modules/opensearch"

  # Domain
  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  advanced_security_options = {
    enabled                        = false
    anonymous_auth_enabled         = true
    internal_user_database_enabled = true

    master_user_options = {
      master_user_name     = "admin"
      master_user_password = random_password.es.result
    }
  }

  auto_tune_options = {
    desired_state = "ENABLED"

    maintenance_schedule = [
      {
        start_at                       = "2028-05-13T07:44:12Z"
        cron_expression_for_recurrence = "cron(0 0 ? * 1 *)"
        duration = {
          value = "2"
          unit  = "HOURS"
        }
      }
    ]

    rollback_on_disable = "NO_ROLLBACK"
  }

  cluster_config = {
    instance_count           = var.es_instance_count
    dedicated_master_enabled = true
    dedicated_master_type    = var.es_dedicated_master_type
    instance_type            = coalesce(var.es_instance_type, var.es_dedicated_master_type)

    zone_awareness_config = {
      availability_zone_count = local.ideal_subnet_count
    }

    zone_awareness_enabled = true
  }

  domain_endpoint_options = {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  domain_name = local.name

  ebs_options = {
    ebs_enabled = true
    iops        = var.es_ebs_iops
    throughput  = 125
    volume_type = var.es_volume_type
    volume_size = var.es_volume_size
  }

  encrypt_at_rest = {
    enabled = true
  }

  engine_version = var.es_engine_version

  log_publishing_options = [
    { log_type = "INDEX_SLOW_LOGS" },
    { log_type = "SEARCH_SLOW_LOGS" },
  ]

  application_name = local.name

  admin_principals = var.es_admin_principals

  read_principals = var.es_read_principals

  node_to_node_encryption = {
    enabled = true
  }

  vpc_options = {
    subnet_ids = slice(module.network.private_subnet_ids, 0, min(length(module.network.private_subnet_ids), local.ideal_subnet_count))

  }

  # Security Group rule example
  security_group_rules = {
    ingress_443 = {
      type        = "ingress"
      description = "HTTPS access from VPC"
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      cidr_ipv4   = module.network.vpc.cidr_block
    }
  }

  # Access policy
  access_policy_statements = [
    {
      effect = "Allow"

      principals = [{
        type        = "*"
        identifiers = ["*"]
      }]

      actions = ["es:*"]

      condition = [{
        test     = "IpAddress"
        variable = "aws:SourceIp"
        values   = ["127.0.0.1/32"]
      }]
    }
  ]

  tags = var.tags

  depends_on = [aws_iam_service_linked_role.elasticsearch]
}

resource "random_password" "es" {
  length  = 128
  special = false
}

data "aws_iam_policy_document" "ecs_osis_access" {
  statement {
    sid       = "AllowOpensearchAccess"
    resources = ["*"]
    actions = [
      "ec2:*",
      "osis:*",
    ]
  }
}

module "es_pod_policy" {
  count  = var.elasticsearch_enabled ? 1 : 0
  source = "github.com/thoughtbot/flightdeck//aws/service-account-policy?ref=v0.9.0"

  name = "es-${var.es_application_name}-pods"
  policy_documents = concat(
    module.opensearch[0][*].policy_json,
    [data.aws_iam_policy_document.ecs_osis_access.json]
  )

  role_names = [module.pod_role.name]
}

data "aws_region" "current" {}
