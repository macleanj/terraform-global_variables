variable "workspaces" {
  description = "connection_string with format [account-profile]__[region]__[environment]"
}
variable "env_size" {
  description = "Size of environment to provision"
  type        = string
  default     = ""
}
variable "instance_type" {
  description = "Instance type to be provisioned"
  type        = string
  default     = ""
}
