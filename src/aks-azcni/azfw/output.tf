output "HUBFW_NAME" {
  value = azurerm_firewall.hubazfw.name
}

output "HUBFW_RG_NAME" {
  value = azurerm_resource_group.hubrg.name
}

output "HUBFW_VNET_NAME" {
  value = azurerm_virtual_network.hubvnet.name
}

output "AZFW_PIP" {
  value = azurerm_public_ip.azfwpip.ip_address
}

