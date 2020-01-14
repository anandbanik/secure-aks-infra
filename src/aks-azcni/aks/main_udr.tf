resource "azurerm_route_table" "vdmzudr" {
  name                = "${var.CLUSTER_ID}routetable"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  route {
    name                   = "vDMZ"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = data.azurerm_firewall.hubfw.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "vdmzudr" {
  subnet_id      = azurerm_subnet.akssubnet[0].id
  route_table_id = azurerm_route_table.vdmzudr.id
}

