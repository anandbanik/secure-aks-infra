resource "azurerm_eventhub_namespace" "eh" {
  name                = "${var.CLUSTER_ID}-ehnamespace"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard"
  capacity            = 2

  tags = {
    costcenter           = var.COST_CENTER
    deploymenttype       = var.DEPLOY_TYPE
    environmentinfo      = var.ENVIRONMENT
    notificationdistlist = var.NOTIFY_LIST
    ownerinfo            = var.OWNER_INFO
    platform             = var.PLATFORM
    sponsorinfo          = var.SPONSOR_INFO
  }
}

resource "azurerm_eventhub_namespace_authorization_rule" "eh" {
  name                = "${var.CLUSTER_ID}-nsauth-rule"
  namespace_name      = azurerm_eventhub_namespace.eh.name
  resource_group_name = azurerm_resource_group.main.name

  listen = true
  send   = true
  manage = true
}

resource "azurerm_eventhub" "eh" {
  name                = "${var.CLUSTER_ID}-eh1"
  namespace_name      = azurerm_eventhub_namespace.eh.name
  resource_group_name = azurerm_resource_group.main.name

  partition_count   = 2
  message_retention = 1
}

resource "azurerm_eventhub_authorization_rule" "eh" {
  name                = "${var.CLUSTER_ID}-enauth-rule"
  namespace_name      = azurerm_eventhub_namespace.eh.name
  eventhub_name       = azurerm_eventhub.eh.name
  resource_group_name = azurerm_resource_group.main.name

  listen = true
  send   = true
  manage = true
}

resource "azurerm_eventhub_consumer_group" "eh" {
  name                = "${var.CLUSTER_ID}-ehcg"
  namespace_name      = azurerm_eventhub_namespace.eh.name
  eventhub_name       = azurerm_eventhub.eh.name
  resource_group_name = azurerm_resource_group.main.name
  user_metadata       = "some-meta-data"
}

