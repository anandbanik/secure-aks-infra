resource "azurerm_monitor_diagnostic_setting" "aks_diag" {
  name               = "${var.CLUSTER_ID}-diag"
  target_resource_id = azurerm_kubernetes_cluster.main.id
  eventhub_name      = azurerm_eventhub.eh.name
  eventhub_authorization_rule_id  = azurerm_eventhub_namespace_authorization_rule.eh.id
  storage_account_id = azurerm_storage_account.diagstore.id
  depends_on = [
    azurerm_kubernetes_cluster.main,
    azurerm_kubernetes_cluster_node_pool.main,
    azurerm_eventhub.eh,
    azurerm_storage_account.diagstore,
    azurerm_eventhub_namespace_authorization_rule.eh
  ]

  log {
    category = "kube-apiserver"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "kube-controller-manager"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "kube-scheduler"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "kube-audit"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "cluster-autoscaler"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}