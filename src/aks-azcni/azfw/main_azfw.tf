resource "azurerm_virtual_network" "hubvnet" {
  name                = "hubvnet"
  address_space       = ["${var.HUB_VNET_ADDR_SPACE}"]
  location            = "${azurerm_resource_group.hubrg.location}"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"

  tags = {
    costcenter = "${var.COST_CENTER}"
    deploymenttype = "${var.DEPLOY_TYPE}"
    environmentinfo = "${var.ENVIRONMENT}"
    notificationdistlist= "${var.NOTIFY_LIST}"
    ownerinfo = "${var.OWNER_INFO}"
    platform = "${var.PLATFORM}"
    sponsorinfo = "${var.SPONSOR_INFO}"
  }
}

resource "azurerm_subnet" "azfwsubnet" {
  name                      = "${var.HUB_SUBNET_NAMES[count.index]}"
  virtual_network_name      = "${azurerm_virtual_network.aksvnet.name}"
  resource_group_name       = "${azurerm_resource_group.main.name}"
  address_prefix            = "${var.HUB_SUBNET_PREFIXES[count.index]}"
  count                     = "${length(var.HUB_SUBNET_NAMES)}"
}

resource "azurerm_public_ip" "azfwpip" {
  name                = "azfwpip"
  location            = "${azurerm_resource_group.hubrg.location}"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    costcenter = "${var.COST_CENTER}"
    deploymenttype = "${var.DEPLOY_TYPE}"
    environmentinfo = "${var.ENVIRONMENT}"
    notificationdistlist= "${var.NOTIFY_LIST}"
    ownerinfo = "${var.OWNER_INFO}"
    platform = "${var.PLATFORM}"
    sponsorinfo = "${var.SPONSOR_INFO}"
  }
}

resource "azurerm_firewall" "hubazfw" {
  name                = "hubazfw"
  location            = "${azurerm_resource_group.hubrg.location}"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"

  tags = {
    costcenter = "${var.COST_CENTER}"
    deploymenttype = "${var.DEPLOY_TYPE}"
    environmentinfo = "${var.ENVIRONMENT}"
    notificationdistlist= "${var.NOTIFY_LIST}"
    ownerinfo = "${var.OWNER_INFO}"
    platform = "${var.PLATFORM}"
    sponsorinfo = "${var.SPONSOR_INFO}"
  }

  ip_configuration {
    name                          = "configuration"
    subnet_id                     = "${azurerm_subnet.azfwsubnet.id}"
    public_ip_address_id          = "${azurerm_public_ip.azfwpip.id}"
  }
}

resource "azurerm_firewall_application_rule_collection" "appruleazfw" {
 name                = "AzureFirewallAppCollection"
 azure_firewall_name = "${azurerm_firewall.hubazfw.name}"
 resource_group_name = "${azurerm_resource_group.hubrg.name}"
 priority            = 100
 action              = "Allow"
 rule {
   name = "hcp_rules"
   source_addresses = [
     "*",
   ]
   target_fqdns = [
     "*.hcp.${var.REGION}.azmk8s.io", #This address is the API server endpoint. Replace <location> with the region where your AKS cluster is deployed.
     "*.tun.${var.REGION}.azmk8s.io", #This address is the API server endpoint. Replace <location> with the region where your AKS cluster is deployed.
     "aksrepos.azurecr.io", #This address is required to access images in Azure Container Registry (ACR).
     "*.blob.core.windows.net", #This address is the backend store for images stored in ACR.
     "mcr.microsoft.com", #This address is required to access images in Microsoft Container Registry (MCR).
     "*.cdn.mscr.io", #This address is required for MCR storage backed by the Azure content delivery network (CDN).
     "login.microsoftonline.com",
     "management.azure.com", #This address is required for Kubernetes GET/PUT operations.
     "api.snapcraft.io", #This address is required to install Snap packages on Linux nodes.
     "*.docker.io" #This address is required to pull required container images for the tunnel front.
   ]
   protocol {
       port = "443"
       type = "Https"
   }
 }
 rule {
   name = "dockerReg_rules"
   source_addresses = [
     "*",
   ]
   target_fqdns = [
     "${var.DOCKER_REGISTRY}", #FQDN for Private registry
     "*.cloudflare.docker.com" #FQDN used by docker.io for CDN of images.
   ]
   protocol {
       port = "443"
       type = "Https"
   }
 }
 rule {
   name = "aks_support_rules"
   source_addresses = [
     "*",
   ]
   target_fqdns = [
     "packages.microsoft.com", #This address is the Microsoft packages repository used for cached apt-get operations.
     "gov-prod-policy-data.trafficmanager.net", #This address is used for correct operation of Azure Policy (currently in preview in AKS).
     "nvidia.github.io", #This address is used for correct driver installation and operation on GPU-based nodes.
     "acs-mirror.azureedge.net",
     "usage.projectcalico.org",
     "apt.dockerproject.org" #This address is used for correct driver installation and operation on GPU-based nodes.
   ]
   protocol {
       port = "443"
       type = "Https"
   }
 }
 rule {
   name = "aks_support_rules2"
   source_addresses = [
     "*",
   ]
   target_fqdns = [
     "*.ubuntu.com", #This address lets the Linux cluster nodes download the required security patches and updates.
     "api.snapcraft.io" #This address is required to install Snap packages on Linux nodes. Uses both port 80 and 443
   ]
   protocol {
       port = "80"
       type = "Http"
   }
 }
 
}
resource "azurerm_firewall_network_rule_collection" "netruleazfw-ports" {
 name                = "AzureFirewallNetCollection-ports"
 azure_firewall_name = "${azurerm_firewall.hubazfw.name}"
 resource_group_name = "${azurerm_resource_group.hubrg.name}"
 priority            = 200
 action              = "Allow"
 rule {
   name = "AllowTCPOutbound"
   source_addresses = [
     "*",
   ]
   destination_ports = [
     "22", #TCP Port used by TunnelFront(legacy but still on some systems)
     "9000" #TCP Port used by TunnelFront
   ]
   destination_addresses = [
     "*"
   ]
   protocols = [
     "TCP"
   ]
}
 rule {
   name = "AllowUDPOutbound"
   source_addresses = [
     "*",
   ]
   destination_ports = [
     "53", #Port used for DNS
     "123" #UDP port used for time services
   ]
   destination_addresses = [
     "*"
   ]
   protocols = [
     "UDP"
   ]
 }
  
}