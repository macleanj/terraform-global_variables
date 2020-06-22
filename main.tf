locals {
  default_account_profile = "default"
  default_region          = "us-east-1"
  default_environment     = "dev"
  provider                = "CrossLogic"

  # Connection string handing:
  # "default" workspace maps to default input values, otherwise workspace is parsed to get the input values. No error handling.
  input_account_profile = var.workspaces == "default" ? local.default_account_profile : regex("([^_]*_?[^_]*_?[^_]*_?[^_]+)__([^_]*_?[^_]*_?[^_]*_?[^_]+)__([^_]*_?[^_]*_?[^_]*_?[^_]+)", var.workspaces)[0]
  input_region          = var.workspaces == "default" ? local.default_region : regex("([^_]*_?[^_]*_?[^_]*_?[^_]+)__([^_]*_?[^_]*_?[^_]*_?[^_]+)__([^_]*_?[^_]*_?[^_]*_?[^_]+)", var.workspaces)[1]
  input_environment     = var.workspaces == "default" ? local.default_environment : regex("([^_]*_?[^_]*_?[^_]*_?[^_]+)__([^_]*_?[^_]*_?[^_]*_?[^_]+)__([^_]*_?[^_]*_?[^_]*_?[^_]+)", var.workspaces)[2]

  # "all" workspace sub-string maps to default input values.
  pass1_account_profile = local.input_account_profile == "all" ? local.default_account_profile : local.input_account_profile
  pass1_region          = local.input_region == "all" ? local.default_region : local.input_region
  pass1_environment     = local.input_environment == "all" ? local.default_environment : local.input_environment

  # Input values verification and normalization. Check if the offered element is supported.
  account_profile = contains(keys(var.specific-config), local.pass1_account_profile) ? local.pass1_account_profile : "Not a supported account_profile"  # Replying "Not a supported account_profile" for unknown account_profile. No error handling.
  region          = contains(keys(var.specific-config[local.account_profile]), local.pass1_region) ? local.pass1_region : "Not a supported region"      # Replying "Not a supported region" for unknown regions. No error handling.
  environment     = contains(keys(var.specific-config[local.account_profile][local.region]), local.pass1_environment) ? local.pass1_environment : "dev" # Using dev for unknown terraform environments. No error handling.

  # Global configurations
  global-config = var.global-config
  env_size      = var.environment_to_size_map[local.environment] # Using default sizing accorinding to the environment
  instance_type = var.instance_type_map[local.env_size]
  region_short  = local.global-config.region_short["${local.region}"]
  continent     = local.global-config.continent["${local.region}"]
  country       = local.global-config.country["${local.region}"]

  # Account-wide configurations
  account-wide-config = var.account-wide-config[local.account_profile]

  # Environment specific configurations
  specific-config = var.specific-config[local.account_profile][local.region][local.environment]
  # TBD: ip_offset to subnet_base calculation
  # reg(50).acc(15)/env(15)
  #  (10.0.0.0/8, 172.16.0.0/12, and 192.168.0.0/16) or RFC 6598 range (100.64.0.0/10)
}

# NOTE: OFFSET NOT USED. ONLY subnet_base and profile verification
variable "specific-config" {
  description = "Config of account, region, and environment specific settings"
  type        = map
  default = {
    default = {
      us-east-1 = {
        dev = {
          ip_offset   = [1, 1, 0]
          subnet_base = "NA"
        }
        test = {
          ip_offset   = [1, 1, 10]
          subnet_base = "NA"
        }
        qa = {
          ip_offset   = [1, 1, 20]
          subnet_base = "NA"
        }
        staging = {
          ip_offset   = [1, 1, 30]
          subnet_base = "NA"
        }
        prod = {
          ip_offset   = [1, 1, 40]
          subnet_base = "NA"
        }
      }
      eu-west-1 = {
        dev = {
          ip_offset   = [1, 2, 0]
          subnet_base = "NA"
        }
        test = {
          ip_offset   = [1, 2, 10]
          subnet_base = "NA"
        }
        qa = {
          ip_offset   = [1, 2, 20]
          subnet_base = "NA"
        }
        staging = {
          ip_offset   = [1, 2, 30]
          subnet_base = "NA"
        }
        prod = {
          ip_offset   = [1, 2, 40]
          subnet_base = "NA"
        }
      }
    }
    jm-jerome = {
      us-east-1 = {
        dev = {
          ip_offset   = [2, 1, 1]
          subnet_base = "NA"
        }
        test = {
          ip_offset   = [2, 1, 2]
          subnet_base = "NA"
        }
        qa = {
          ip_offset   = [2, 1, 3]
          subnet_base = "NA"
        }
        staging = {
          ip_offset   = [2, 1, 4]
          subnet_base = "NA"
        }
        prod = {
          ip_offset   = [2, 1, 5]
          subnet_base = "NA"
        }
      }
      eu-west-1 = {
        dev = {
          ip_offset   = [2, 2, 1]
          subnet_base = "NA"
        }
        test = {
          ip_offset   = [2, 2, 2]
          subnet_base = "NA"
        }
        qa = {
          ip_offset   = [2, 2, 3]
          subnet_base = "NA"
        }
        staging = {
          ip_offset   = [2, 2, 4]
          subnet_base = "NA"
        }
        prod = {
          ip_offset   = [2, 2, 5]
          subnet_base = "NA"
        }
      }
    }
    jm-jerome-prod = {
      us-east-1 = {
        dev = {
          ip_offset   = [3, 1, 1]
          subnet_base = "NA"
        }
        test = {
          ip_offset   = [3, 1, 2]
          subnet_base = "NA"
        }
        qa = {
          ip_offset   = [3, 1, 3]
          subnet_base = "NA"
        }
        staging = {
          ip_offset   = [3, 1, 4]
          subnet_base = "NA"
        }
        prod = {
          ip_offset   = [3, 1, 5]
          subnet_base = "NA"
        }
      }
      eu-west-1 = {
        dev = {
          ip_offset   = [3, 2, 1]
          subnet_base = "NA"
        }
        test = {
          ip_offset   = [3, 2, 2]
          subnet_base = "NA"
        }
        qa = {
          ip_offset   = [3, 2, 3]
          subnet_base = "NA"
        }
        staging = {
          ip_offset   = [3, 2, 4]
          subnet_base = "NA"
        }
        prod = {
          ip_offset   = [3, 2, 5]
          subnet_base = "NA"
        }
      }
    }
    jm-jerome-dev = {
      us-east-1 = {
        dev = {
          ip_offset   = [4, 1, 1]
          subnet_base = "NA"
        }
        test = {
          ip_offset   = [4, 1, 2]
          subnet_base = "NA"
        }
        qa = {
          ip_offset   = [4, 1, 3]
          subnet_base = "NA"
        }
        staging = {
          ip_offset   = [4, 1, 4]
          subnet_base = "NA"
        }
        prod = {
          ip_offset   = [4, 1, 5]
          subnet_base = "NA"
        }
      }
      eu-west-1 = {
        dev = {
          ip_offset   = [4, 2, 1]
          subnet_base = "NA"
        }
        test = {
          ip_offset   = [4, 2, 2]
          subnet_base = "NA"
        }
        qa = {
          ip_offset   = [4, 2, 3]
          subnet_base = "NA"
        }
        staging = {
          ip_offset   = [4, 2, 4]
          subnet_base = "NA"
        }
        prod = {
          ip_offset   = [4, 2, 5]
          subnet_base = "NA"
        }
      }
    }
    free-tier-dev = {
      us-east-1 = {
        dev = {
          ip_offset   = [5, 1, 1]
          subnet_base = "10.101"
        }
        test = {
          ip_offset   = [5, 1, 2]
          subnet_base = "NA"
        }
        qa = {
          ip_offset   = [5, 1, 3]
          subnet_base = "NA"
        }
        staging = {
          ip_offset   = [5, 1, 4]
          subnet_base = "NA"
        }
        prod = {
          ip_offset   = [5, 1, 5]
          subnet_base = "NA"
        }
      }
      eu-west-1 = {
        dev = {
          ip_offset   = [5, 2, 1]
          subnet_base = "11.101"
        }
        test = {
          ip_offset   = [5, 2, 2]
          subnet_base = "NA"
        }
        qa = {
          ip_offset   = [5, 2, 3]
          subnet_base = "NA"
        }
        staging = {
          ip_offset   = [5, 2, 4]
          subnet_base = "NA"
        }
        prod = {
          ip_offset   = [5, 2, 5]
          subnet_base = "NA"
        }
      }
    }
    cl-website-prod-jerome = {
      us-east-1 = {
        dev = {
          ip_offset   = [6, 1, 1]
          subnet_base = "NA"
        }
        test = {
          ip_offset   = [6, 1, 2]
          subnet_base = "NA"
        }
        qa = {
          ip_offset   = [6, 1, 3]
          subnet_base = "NA"
        }
        staging = {
          ip_offset   = [6, 1, 4]
          subnet_base = "NA"
        }
        prod = {
          ip_offset   = [6, 1, 5]
          subnet_base = "NA"
        }
      }
      eu-west-1 = {
        dev = {
          ip_offset   = [6, 2, 1]
          subnet_base = "NA"
        }
        test = {
          ip_offset   = [6, 2, 2]
          subnet_base = "NA"
        }
        qa = {
          ip_offset   = [6, 2, 3]
          subnet_base = "NA"
        }
        staging = {
          ip_offset   = [6, 2, 4]
          subnet_base = "NA"
        }
        prod = {
          ip_offset   = [6, 2, 5]
          subnet_base = "NA"
        }
      }
    }
    cl-website-preprod-jerome = {
      us-east-1 = {
        dev = {
          ip_offset   = [7, 1, 1]
          subnet_base = "NA"
        }
        test = {
          ip_offset   = [7, 1, 2]
          subnet_base = "NA"
        }
        qa = {
          ip_offset   = [7, 1, 3]
          subnet_base = "NA"
        }
        staging = {
          ip_offset   = [7, 1, 4]
          subnet_base = "NA"
        }
        prod = {
          ip_offset   = [7, 1, 5]
          subnet_base = "NA"
        }
      }
      eu-west-1 = {
        dev = {
          ip_offset   = [7, 2, 1]
          subnet_base = "NA"
        }
        test = {
          ip_offset   = [7, 2, 2]
          subnet_base = "NA"
        }
        qa = {
          ip_offset   = [7, 2, 3]
          subnet_base = "NA"
        }
        staging = {
          ip_offset   = [7, 2, 4]
          subnet_base = "NA"
        }
        prod = {
          ip_offset   = [7, 2, 5]
          subnet_base = "NA"
        }
      }
    }
  }
}

variable "account-wide-config" {
  description = "Config of settings on a region-wide level"
  type        = map
  default = {
    default = {
      route53 = {
        zone_name_private = "aws.internal"
      }
    }
    jm-jerome = {
      route53 = {
        zone_name_private = "aws.internal"
      }
    }
    jm-jerome-prod = {
      route53 = {
        zone_name_private = "prod.internal"
      }
    }
    jm-jerome-dev = {
      route53 = {
        zone_name_private = "dev.internal"
      }
    }
    free-tier-dev = {
      route53 = {
        zone_name_private = "aws.internal"
      }
    }
    cl-website-prod-jerome = {
      route53 = {
        zone_name_private = "aws.internal"
      }
    }
    cl-website-preprod-jerome = {
      route53 = {
        zone_name_private = "aws.internal"
      }
    }
  }
}

variable "global-config" {
  description = "Config of settings on a region-wide level"
  type        = map
  default = {
    region_short = {
      # Per "aws ec2 describe-availability-zones --region <region>
      us-east-1    = "use1" # Most AWS services in US
      us-east-2    = "use2"
      us-west-1    = "usw1"
      us-west-2    = "usw2"
      eu-west-1    = "euw1" # Most AWS services in EU
      eu-central-1 = "euc2"
      eu-north-1   = "eun1"
    }
    continent = {
      # Per https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resource-record-sets-values-geo.html#rrsets-values-geo-location
      us-east-1    = "NA"
      us-east-2    = "NA"
      us-west-1    = "NA"
      us-west-2    = "NA"
      eu-west-1    = "EU"
      eu-central-1 = "EU"
      eu-north-1   = "EU"
    }
    country = {
      # Per https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resource-record-sets-values-geo.html#rrsets-values-geo-location
      us-east-1    = "US"
      us-east-2    = "US"
      us-west-1    = "US"
      us-west-2    = "US"
      eu-west-1    = "IE"
      eu-central-1 = "DE"
      eu-north-1   = "SE"
    }
    route53 = {
      zone_name_public = "aws.crosslogic-consulting.com"
    }
    s3 = {
      regional_logging = "regional-logging"
      central_logging  = "central-logging"
      central_state    = "central-state"
    }
    eks = {
      cluster_name = "EKS-shared-testing"
    }
  }
}

# Maps environment to environment size (abstracted)
variable "environment_to_size_map" {
  description = "Mapping size to environment"
  type        = map
  default = {
    dev     = "micro"
    test    = "small"
    qa      = "medium"
    staging = "large"
    prod    = "xlarge"
  }
}
variable "instance_type_map" {
  description = "A map from size to the type of EC2 instance"
  type        = map
  default = {
    micro   = "t2.micro" # Free tier eligible
    small   = "t2.small"
    medium  = "t2.medium"
    large   = "m4.large"
    xlarge  = "m5.xlarge"
    xlarge2 = "m5.2xlarge"
  }
}

# Overview of tags that should be used. First choose one of these tags before inventing a new one with similar purpose (consistency).
# Must be "locals" when using variables inside
locals {
  standard_tags = {
    # Technical Tags
    Workspace       = var.workspaces    # The terraform.workspace of the release engineer
    Environment     = local.environment # Used to distinguish between dev, test, stag, and prod infrastructure. Set by terraform.workspace
    Usage           = "Not set"         # How is this resource going to be used
    Description     = "Not set"         # General description of the rousource
    Tier            = "Not set"         # frontend, backend, storage, network
    Namespace       = "Not set"         # Area of operation. E.g. EKS, VPC, RDS, etc
    ApplicationID   = "Not set"         # Used to identify disparate resources that are related to a specific application
    ApplicationName = "Not set"         # Used to identify resources groupas that are related to a specific application
    ApplicationRole = "Not set"         # Used to describe the function of a particular resource (e.g. web server, message broker, database)
    OS              = "Not set"         # Operating System family
    OsVersion       = "Not set"         # Operating System version
    Cluster         = "Not set"         # Used to identify resource farms that share a common configuration and perform a specific function for an application
    Provider        = local.provider    # Owner of the entire platform. This tag is used for global resources.
    Version         = "Not set"         # Used to help distinguish between different versions of resources or applications

    # Automation Tags
    Creator      = "Terraform"  # Creator of the resources
    CreationDate = "YYYY-MM-DD" # Date
    Opt          = "Not set"    # Opt in/Opt out: Used to indicate whether a resource should be automatically included in an automated activity such as starting, stopping, or resizing instances
    Security     = "Not set"    # Used to determine requirements such as encryption or enabling of VPC Flow Logs, and also to identify route tables or security groups that deserve extra scrutiny

    # Business Tags
    Owner        = "Jerome Mac Lean" # Used to identify who is responsible for the resource
    BusinessUnit = "Not set"         # Used to identify the cost center or business unit associated with a resource; typically for cost allocation and tracking
    Customer     = "Not set"         # Used to identify a specific client that a particular group of resources serves
    Project      = "Not set"         # Used to identify the project(s) the resource supports

    # Security Tags
    Confidentiality = "Not set" # An identifier for the specific data-confidentiality level a resource supports
    Compliance      = "Not set" # An identifier for workloads designed to adhere to specific compliance requirements
  }
}