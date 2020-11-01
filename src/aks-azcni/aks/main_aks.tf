
resource "azurerm_kubernetes_cluster" "main" {
  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count,
      api_server_authorized_ip_ranges,
      kubernetes_version
      ]
  }
  name                = var.CLUSTER_ID
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = var.CLUSTER_ID
  kubernetes_version  = var.K8S_VER


  depends_on = [
   azurerm_subnet.akssubnet,
   azurerm_subnet_route_table_association.vdmzudr
]

  linux_profile {
    admin_username = var.ADMIN_USER

    ssh_key {
      key_data = var.AKS_SSH_ADMIN_KEY
    }
  }

  default_node_pool {
    name            = var.POOL1_NAME
    type            = "VirtualMachineScaleSets"
    node_count           = var.POOL1_MIN
    enable_auto_scaling = var.ENABLE_CA_POOL1
    min_count       = var.POOL1_MIN
    max_count       = var.POOL1_MAX
    vm_size         = var.POOL1_NODE_SIZE
    os_disk_size_gb = 128
    vnet_subnet_id  = azurerm_subnet.akssubnet[0].id
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "calico"
    service_cidr = var.SERVICE_CIDR
    dns_service_ip = var.DNS_IP
    docker_bridge_cidr = var.DOCKER_CIDR
    load_balancer_sku = "standard"
  }

  role_based_access_control {
    enabled = true
    # azure_active_directory {
    #   # NOTE: in a Production environment these should be different values
    #   # but for the purposes of this example, this should be sufficient
    #   client_app_id = "${var.AAD_CLIENTAPP_ID}"

    #   server_app_id     = "${var.AAD_SERVERAPP_ID}"
    #   server_app_secret = "${var.AAD_SERVERAPP_SECRET}"
    # }
  }

  # MUST USE PRE_CREATED SERVICE PRINCIPAL WITH POPER ROLE ASSIGNMENT 
  # FOR AKS SEE https://docs.microsoft.com/en-us/azure/aks/kubernetes-service-principal#manually-create-a-service-principal
  service_principal {
    client_id     = var.K8S_SP_CLIENT_ID
    client_secret = var.K8S_SP_CLIENT_SECRET
  }

  api_server_authorized_ip_ranges = tolist(concat(split(",",var.AUTH_IP_RANGES),list("${var.AZFW_PIP}/32")))
    #[split(",",var.AUTH_IP_RANGES)],
    #"${var.AZFW_PIP}/32"
    #split(",",var.AUTH_IP_RANGES)
  

  enable_pod_security_policy = "true"
 }

resource "azurerm_kubernetes_cluster_node_pool" "main" {
  lifecycle {
    ignore_changes = [
      node_count
    ]
  }

  kubernetes_cluster_id   = azurerm_kubernetes_cluster.main.id
  name                    = var.POOL2_NAME
  node_count              = var.POOL2_MIN
  enable_auto_scaling   = var.ENABLE_CA_POOL2
  min_count             = var.POOL2_MIN
  max_count             = var.POOL2_MAX
  vm_size               = var.POOL2_NODE_SIZE
  os_disk_size_gb       = 128
  vnet_subnet_id        = azurerm_subnet.akssubnet[0].id
  os_type               = "Linux"
}