data "dns_a_record_set" "apiIP" {
  host = azurerm_kubernetes_cluster.main.fqdn
  depends_on = [
    azurerm_kubernetes_cluster.main,
    azurerm_kubernetes_cluster_node_pool.main
  ]
}

resource "azurerm_firewall_network_rule_collection" "netruleapifw" {
  name                = "AzureFirewallNetCollection-API"
  azure_firewall_name = data.azurerm_firewall.hubfw.name
  resource_group_name = var.HUBFW_RG_NAME
  priority            = 201
  action              = "Allow"

  depends_on = [
    azurerm_kubernetes_cluster.main,
    data.dns_a_record_set.apiIP
  ]

  rule {
    name = "AllowAKSAPI_IPOutbound"

    source_addresses = [
      "*",
    ]

    destination_ports = [
      "443"
    ]

    destination_addresses = [
      join(",",data.dns_a_record_set.apiIP.addrs)
    ]

    protocols = [
      "TCP"
    ]
  }
}
