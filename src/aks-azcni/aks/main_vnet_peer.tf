# data "azurerm_virtual_network" "hub" {
#   name                = "${azurerm_virtual_network.hubvnet}"
#   resource_group_name = "${azurerm_resource_group.main.name}"
#   location            = "${azurerm_resource_group.main.location}"
# }
data "azurerm_firewall" "hubfw" {
  name = var.HUBFW_NAME
  resource_group_name = var.HUBFW_RG_NAME
}

data "azurerm_virtual_network" "hubvnet" {
  name = var.HUBFW_VNET_NAME
  resource_group_name = var.HUBFW_RG_NAME
}

resource "azurerm_virtual_network_peering" "hub-to-aks" {
  name                         = "hub-to-aks"
  resource_group_name          = var.HUBFW_RG_NAME
  virtual_network_name         = var.HUBFW_VNET_NAME
  remote_virtual_network_id    = azurerm_virtual_network.aksvnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = true
}

resource "azurerm_virtual_network_peering" "aks-to-hub" {
  name                         = "aks-to-hub"
  resource_group_name          = azurerm_resource_group.main.name
  virtual_network_name         = azurerm_virtual_network.aksvnet.name
  remote_virtual_network_id    = data.azurerm_virtual_network.hubvnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}