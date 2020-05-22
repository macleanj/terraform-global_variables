####################################
# Template !!!!!
####################################

locals {
  # Generic variable (lowercase).
  namespace      = "shared"                                                            # Purpose of the resourse (describing the function of the resource)
  usage          = "testing"                                                           # How is this resource going to be used
  resources_name = "${local.namespace}-${local.usage}-${module.variables.environment}" # This is the convention we use to know what belongs to each other

  # Tags are overwritten/updated per resource creation
  standard_tags = {
    for key, value in merge(
      # standard_tags_raw = merge(
      module.variables.standard_tags,
      {
        Namespace       = local.namespace
        Usage           = local.usage
        Owner           = "Jerome Mac Lean"
        CreationDate    = "2019-11-29"
        Version         = "1.0"
        Description     = "VPC for testing purposes"
        Tier            = "network"
        ApplicationID   = null
        ApplicationName = null
        ApplicationRole = null
        OS              = null
        OsVersion       = null
        Cluster         = null
        Opt             = null
        Security        = null
        BusinessUnit    = null
        Customer        = null
        Project         = null
        Confidentiality = null
        Compliance      = null
      }
    ) :
    key => value if(value != null)
  }
}

####################################
# Advanced settings
####################################

# May override size based on terraform.workspace
# Synopsis: "terraform.workspace" = "size"
variable "workspace_to_size_map" {
  description = "Mapping size to environment"
  type        = map
  default = {
    dev = "micro"
  }
}

####################################
# Do not change byond this point (except source path of module "variables")
####################################

# Fetch all global variables
module "variables" {
  source = "../"
  # connection_string:
  # workspaces must have format [account-profile]__[region]__[environment]
  # connection_string "default" allowed. Defaults will be used.
  workspaces = terraform.workspace
}

locals {
  # Using sizing accorinding to the workspace/environment
  env_size = "${module.variables.environment == "dev" ? lookup(var.workspace_to_size_map, terraform.workspace, "micro") : module.variables.env_size}"
}

