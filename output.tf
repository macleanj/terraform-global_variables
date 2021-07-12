output "workspace" {
  value = var.workspaces
}
output "account_profile" {
  value = local.account_profile
}
output "region" {
  value = local.region
}
output "region_short" {
  value = local.region_short
}
output "continent" {
  value = local.continent
}
output "country" {
  value = local.country
}
output "environment" {
  value = local.environment
}
output "environment_short" {
  value = regex("^[a-z]{1}", local.environment)
}
output "provider" {
  value = local.provider
}
output "subnet_base" {
  value = local.specific-config.subnet_base
}
output "zone_name_private" {
  value = local.account-wide-config.route53.zone_name_private
}
output "s3_regional_logging" {
  value = lower("${local.region_short}-${local.global-config.s3.regional_logging}")
}
output "s3_central_logging" {
  value = lower(local.global-config.s3.central_logging)
}
output "s3_central_state" {
  value = lower(local.global-config.s3.central_state)
}
output "eks_cluster_name" {
  value = lower(local.global-config.eks.cluster_name)
}
output "zone_name_public" {
  value = local.global-config.route53.zone_name_public
}
output "env_size" {
  value = local.env_size
}
output "instance_type" {
  value = local.instance_type
}
output "standard_tags" {
  value = local.standard_tags
}
output "standard_annotations" {
  value = local.standard_annotations
}
