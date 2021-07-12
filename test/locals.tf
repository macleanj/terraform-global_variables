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

  standard_propagate_tags = flatten([
    for key, value in local.standard_tags : {
      key                 = key
      value               = value
      propagate_at_launch = "true"
    }
  ])

  standard_metatdata_tags = {
    for key, value in local.standard_tags :
      replace(lower(key), "/[^-a-zA-Z0-9_.]/", "_") => replace(lower(value), "/[^-a-zA-Z0-9_.]/", "_")
  }

  standard_annotations = {
    for key, value in merge(
      module.variables.standard_annotations,
      {}
    ) :
    key => value if(value != null)
  }

  # Specific variable (not used by module)
  #
  #
}

########################################################################
# Advanced settings. Do not change unless you know what you are doing.
########################################################################

# Fetch all global variables
module "variables" {
  source = "../"
  # connection_string:
  # workspaces must have format [account-profile]__[region]__[environment]
  # connection_string "default" allowed. Defaults will be used.
  workspaces = terraform.workspace
  # env_size        = "small"    # Overwrites size based on environment. Also controls related resources.
  # instance_type   = "t2.small" # Overwrites instance_type based on env_size. Controls instance_type only.
}
