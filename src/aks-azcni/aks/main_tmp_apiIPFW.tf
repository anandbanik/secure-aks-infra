resource "azurerm_firewall_network_rule_collection" "netruleazfw-temp" {
  name                = "AzureFirewallNetCollection-API-TEMP"
  azure_firewall_name = data.azurerm_firewall.hubfw.name
  resource_group_name = var.HUBFW_RG_NAME
  priority            = 210
  action              = "Allow"

  depends_on = [azurerm_resource_group.main]

  rule {
    name = "AllowTempAPIAccess"
    source_addresses = [
      "*",
    ]
    destination_ports = [
      "443",
    ]
    destination_addresses = [
      "AzureCloud.${var.REGION}",
    ]
    protocols = [
      "TCP",
    ]
  }
}

