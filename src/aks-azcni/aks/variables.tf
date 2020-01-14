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

variable "COST_CENTER" {
  description = "Cost center #"
}

variable "DEPLOY_TYPE" {
  description = "Deployment type for tags"
}

variable "ENVIRONMENT" {
  description = "Environment info"
}

variable "NOTIFY_LIST" {
  description = "notification list"
}

variable "OWNER_INFO" {
  
}
variable "PLATFORM" {
  
}

variable "SPONSOR_INFO" {
  
}
/*
 * VNET
 */
variable "VNET_NAME" {
  type = "string"
}
variable "VNET_ADDR_SPACE" {
  description = "The address space that is used by the virtual network."
  default     = "10.10.0.0/16"
}

variable "DNS_SERVERS" {
  description = "The DNS servers to be used with vNet."
  default     = []
}
variable "SUBNET_NAMES" {
  description = "A list of public subnets inside the vNet."
  default     = ["aks-subnet"]
}
variable "SUBNET_PREFIXES" {
  description = "The address prefix to use for the subnet."
  default     = ["10.10.1.0/24"]
}

/*
 * AKS
 */

variable "AKS_SSH_ADMIN_KEY" {
  description = "Admin SSH Public Key for AKS Agent VMs"
}
variable "K8S_VER" {
  type = "string"
}

variable "ADMIN_USER" {
  type = "string"
}

variable "POOL1_NODE_SIZE" {
  type = "string"
}
variable "POOL2_NODE_SIZE" {
  type = "string"
}
variable "SERVICE_CIDR" {
  default = "172.16.0.0/16"
  description ="Used to assign internal services in the AKS cluster an IP address. This IP address range should be an address space that isn't in use elsewhere in your network environment. This includes any on-premises network ranges if you connect, or plan to connect, your Azure virtual networks using Express Route or a Site-to-Site VPN connections."
  type = "string"
}
variable "DNS_IP" {
  default = "172.16.0.10"
  description = "should be the .10 address of your service IP address range"
  type = "string"
}
variable "DOCKER_CIDR" {
  default = "172.17.0.1/16"
  description = "IP address (in CIDR notation) used as the Docker bridge IP address on nodes. Default of 172.17.0.1/16."
}

variable "POD_CIDR" {
  default="172.18.0.0/16"
  description="IP address (in CIDR notation) used as the POD IP address on nodes. CIDR must be large enough to be spliot in /24 by each node in cluster. This IP address range should be an address space that isn't in use elsewhere in your network environment. This includes any on-premises network ranges if you connect, or plan to connect, your Azure virtual networks using Express Route or a Site-to-Site VPN connections."
}

# variable "AAD_CLIENTAPP_ID" {
#   type = "string"
# }

# variable "AAD_SERVERAPP_ID" {
#   type = "string"
# }

# variable "AAD_SERVERAPP_SECRET" {
#   type = "string"
# }

variable "AUTH_IP_RANGES" {
  type="string"
}

variable "ENABLE_CA_POOL1" {
  type="string"
}
variable "ENABLE_CA_POOL2" {
  type="string"
}
variable "POOL1_NAME" {
  type="string"
}

variable "POOL1_MIN" {
  type="string"
}

variable "POOL1_MAX" {
  type="string"
}

variable "POOL2_NAME" {
  type="string"
}

variable "POOL2_MIN" {
  type="string"
}

variable "POOL2_MAX" {
  type="string"
}

variable "K8S_SP_CLIENT_ID" {
  type="string"
}

variable "K8S_SP_CLIENT_SECRET" {
  type="string"
}



/*
 * K8S
 */

variable "DOCKER_REGISTRY" {
  type="string"
}
/*
 * Hub VNET INfo from Output of AZFW Terrafrom Module Deployment
 */
variable "HUBFW_NAME" {
  
}

variable "HUBFW_RG_NAME" {
  
}

variable "HUBFW_VNET_NAME" {
  
}

variable "AZFW_PIP" {
  
}