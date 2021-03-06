resource "null_resource" "kubenet_udr" {
  depends_on = ["azurerm_virtual_network.aksvnet",
  "azurerm_subnet.akssubnet",
  "azurerm_kubernetes_cluster.main",
  "azurerm_kubernetes_cluster_node_pool.main"
  ]
  provisioner "local-exec" {
          command = "./rtnsg-fix.sh"

          environment {
              AKS_RG = "${azurerm_resource_group.main.name}"
              AKS_VNET_RG = "${azurerm_resource_group.main.name}"
              AKS_VNET_NAME = "${azurerm_virtual_network.aksvnet.name}"
              AKS_SUBNET_NAME = "${azurerm_subnet.akssubnet.name}"
              AZFW_INT_IP = "${data.azurerm_firewall.hubfw.ip_configuration.0.private_ip_address}"
              AZ_CLIENT_ID="${var.TF_CLIENT_ID}"
              AZ_CLIENT_SECRET="${var.TF_CLIENT_SECRET}"
              AZ_TENANT_ID="${var.TF_TENANT_ID}"
          }
      }

      provisioner "local-exec" {
          when = "destroy"
          command = "./rtnsg-rm.sh"
          
          environment {
              AKS_VNET_RG = "${azurerm_resource_group.main.name}"
              AKS_VNET_NAME = "${azurerm_virtual_network.aksvnet.name}"
              AKS_SUBNET_NAME = "${azurerm_subnet.akssubnet.name}"
              AZ_CLIENT_ID="${var.TF_CLIENT_ID}"
              AZ_CLIENT_SECRET="${var.TF_CLIENT_SECRET}"
              AZ_TENANT_ID="${var.TF_TENANT_ID}"
          }
      }
}