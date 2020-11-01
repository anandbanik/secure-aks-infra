locals {
  clusterid_encode = "${lower("${md5("${var.CLUSTER_ID}")}")}"
}

resource "azurerm_storage_account" "diagstore" {
  name                     = "diag${substr("${local.clusterid_encode}",0,10)}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

}
