module "s3_bucket" {
  count  = var.s3_enabled ? 1 : 0
  source = "github.com/thoughtbot/terraform-s3-bucket?ref=v0.3.0"

  name                 = var.s3_bucket_name
  read_principals      = concat(local.read_principals, var.s3_read_principals)
  readwrite_principals = concat(local.readwrite_principals, var.s3_readwrite_principals)
}
