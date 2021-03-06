output "workspace" {
  value = module.variables.workspace
}
output "account_profile" {
  value = module.variables.account_profile
}
output "region" {
  value = module.variables.region
}
output "region_short" {
  value = module.variables.region_short
}
output "environment" {
  value = module.variables.environment
}
output "environment_short" {
  value = module.variables.environment_short
}
output "continent" {
  value = module.variables.continent
}
output "country" {
  value = module.variables.country
}
output "provider" {
  value = module.variables.provider
}
output "subnet_base" {
  value = module.variables.subnet_base
}
output "zone_name_private" {
  value = module.variables.zone_name_private
}
output "s3_regional_logging" {
  value = module.variables.s3_regional_logging
}
output "s3_central_logging" {
  value = module.variables.s3_central_logging
}
output "s3_central_state" {
  value = module.variables.s3_central_state
}
output "eks_cluster_name" {
  value = module.variables.eks_cluster_name
}
output "zone_name_public" {
  value = module.variables.zone_name_public
}
output "env_size" {
  value = module.variables.env_size
}
output "instance_type" {
  value = module.variables.instance_type
}
output "standard_tags" {
  value = local.standard_tags
}
output "standard_propagate_tags" {
  value = local.standard_propagate_tags
}
output "standard_metatdata_tags" {
  value = local.standard_metatdata_tags
}
output "standard_annotations" {
  value = local.standard_annotations
}
