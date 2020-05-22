# Global variables
This module facilitates a single point of configuration of the AWS infrastructure. It can control:
- Multiple AWS accounts
- Multiple regions
- Multiple environments

The variables described in this modules can offer:
- Global configuration        (e.g. environment sizing configuration)
- Account wide configuration  (e.f. DNS configuration)
- Specific configurations (per account, region, and environment combination)

The following principles are used:
- A single project can be responsible for provisioning common infrastructure. This can be:
  - Per environment, per region, per account (specific).
  - Per account, for all region and environment or per account only (account-wide).
  - For all account, region, and environments (global).
- a separate tfstate (state-file) is used for every single project.
- as a result of the aforementioned a terraform workspace is created per account, region, and environment combination. Naming convention of the terraform workspaces:
```
[account-profile]__[region]__[environment]

- account-profile : profile-name used in the provider section. E.g. AWS profile name in ~/.aws/config
- region          : e.g. us-east-1 or all
- environment     : e.g. staging or all

Example:
default
jerome-maclean__us-east-1__dev
jerome-maclean__all__all
all__all__all
```
> default is accepted as workspace name. Defaults will apply.

## Example workspace setup
The following config (or similar) is used for multi-dimensional testing:
```
TF_PROFILES=" \
  all__all__all \
  "

TF_PROFILES=" \
  jerome-maclean__all__all \
  jerome-test__all__all \
  "

TF_PROFILES=" \
  jerome-maclean__us-east-1__all \
  jerome-maclean__us-east-2__all \
  "

TF_PROFILES=" \
  jerome-maclean__us-east-1__dev \
  jerome-maclean__us-east-2__dev \
  jerome-test__us-east-1__dev \
  "

# Once to setup the access to the provider
for tf_profile in $TF_PROFILES; do
  account_profile=$(echo $tf_profile | sed -e 's/__.*//g')
  echo "Creating Account Profile: $account_profile"
  aws config --profile $account_profile
done

# Per global project
for tf_profile in $TF_PROFILES; do
  echo "Creating Terraform Workspace: $tf_profile"
  terraform workspace new $tf_profile
done

# Per global project rollout
for tf_profile in $(terraform workspace list | egrep -v "default|^[\s]*$" | sed -e 's/^[[:space:]]*\**[[:space:]]*//g'); do
  echo "Executing Project in Terraform Workspace: ${tf_profile}"
  terraform workspace select $tf_profile
  terraform apply
done
```

## Prerequisite resources
Some resources are a fundamental dependency for other resources and should be configured before any other resources. The following list highlights the prerequisites, incl the configuration items that need to be added to the global configuration:
- Organizations: incl Service Control Policies
- Route53: private (and public) DNS zones
  - zone-id
  - zone-name

## Cross configurations
Some elements may cross the boundaries of the account, region, and environment combination.<br>
Examples are:
- Peering connections
Cross configurations are configured in the variables module, however separate projects will be applied to get around the various dependencies.

<span style="color:red">**TODO:**</span>
- How to deal with (circular) dependencies like DNS over a Peering connection and inter-account IAM roles? Separate project?
> <span style="color:red">**STATUS:** IAM and DNS association will be realized manually for testing: https://aws.amazon.com/blogs/security/how-to-centralize-dns-management-in-a-multi-account-environment/</span>

## Manual configurations
Some items will be configured completely outside the scope of these variable definitions. It might be because the resource is already a global resource (only configured once) or is specific for the account, region, or environment.<br>
The following resources are configured separately:
- S3 storage

## Supportive commands
```
# shown all regions
aws ec2 describe-regions | jq -r '.Regions[].RegionName

# shown all az per regions
aws ec2 describe-availability-zones --region eu-west-1
```