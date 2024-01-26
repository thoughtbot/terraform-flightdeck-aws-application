module "deploy_role" {
  source = "github.com/thoughtbot/terraform-eks-cicd//modules/github-actions-eks-deploy-role?ref=v0.2.0"

  cluster_names         = var.cluster_names
  github_branches       = var.github_branches
  github_organization   = var.github_organization
  github_repository     = var.github_repository
  iam_oidc_provider_arn = var.github_iam_oidc_provider_arn
  name                  = coalesce(var.deploy_role_name, "${local.instance_name}-deploy")

  managed_prometheus_workspace_ids = (
    var.prometheus_workspace_name == null ?
    [] :
    [data.aws_ssm_parameter.prometheus_workspace_id[0].value]
  )
}

data "aws_ssm_parameter" "prometheus_workspace_id" {
  count = var.prometheus_workspace_name != null ? 1 : 0

  name = join("/", concat([
    "",
    "flightdeck",
    "prometheus",
    var.prometheus_workspace_name,
    "workspace_id"
  ]))
}
