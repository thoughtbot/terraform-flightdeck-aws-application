data "aws_availability_zones" "available" {}

locals {
  region = var.es_region
  name   = "es-${var.es_application_name}"
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
  source = "terraform-aws-modules/opensearch/aws"

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
      availability_zone_count = 2
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

  ip_address_type = "dualstack"

  node_to_node_encryption = {
    enabled = true
  }

  software_update_options = {
    auto_software_update_enabled = true
  }

  vpc_options = {
    subnet_ids = module.network.private_subnet_ids
  }

  # VPC endpoint
  vpc_endpoints = {
    one = {
      subnet_ids = module.network.private_subnet_ids
    }
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

module "secret" {
  count  = var.elasticsearch_enabled ? 1 : 0
  source = "github.com/thoughtbot/terraform-aws-secrets//secret?ref=v0.8.0"

  admin_principals = var.admin_principals
  description      = "Elastisearch password for: ${local.name}"
  name             = "${local.name}-secret"
  read_principals  = var.read_principals
  resource_tags    = var.tags

  initial_value = jsonencode({
    ES_ENDPOINT           = module.opensearch.domain_endpoint
    ES_DASHBOARD_ENDPOINT = module.opensearch.domain_dashboard_endpoint
    DOMAIN_ID             = module.opensearch.domain_id
    PASSWORD              = random_password.es.result
  })
}

