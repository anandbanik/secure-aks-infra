/*
 * TF Base
 */
variable "TF_CLIENT_ID" {
  
}
variable "TF_CLIENT_SECRET" {
  
}

variable "TF_TENANT_ID" {
  
}

variable "TF_SUB_ID" {
  
}

/*
 * Common
 */
variable "REGION" {
  
}


variable "CLUSTER_ID" {
  
}

variable "LOG_ANALYTICS_WORKSPACE_NAME" {
  
}

variable "LOG_ANALYTICS_WORKSPACE_RG" {
  
}

/*
 * VNET
 */
variable "HUB_VNET_ADDR_SPACE" {
  description = "The address space that is used by the virtual network."
  default     = "10.0.0.0/16"
}

variable "HUB_SUBNET_NAMES" {
  description = "A list of public subnets inside the vNet."
  default     = ["AzureFirewallSubnet"] # DO NOT CHNAGE!!! THIS IS HARDCODED AND CAN NOT BE CHANGED FOR THE SUBNET THE FIREWALL WILL USE
}
variable "HUB_SUBNET_PREFIXES" {
  description = "The address prefix to use for the subnet."
  default     = ["10.0.1.0/24"]
}
