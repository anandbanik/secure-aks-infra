# Configure the Microsoft Azure Provider


provider "azurerm" {
  version = "~>1.37.0"

  subscription_id = "${var.TF_SUB_ID}"
  client_id       = "${var.TF_CLIENT_ID}"
  client_secret   = "${var.TF_CLIENT_SECRET}"
  tenant_id       = "${var.TF_TENANT_ID}"
}


# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.CLUSTER_ID}"
  location = "${var.REGION}"

  tags {
    costcenter = "${var.COST_CENTER}"
    deploymenttype = "${var.DEPLOY_TYPE}"
    environmentinfo = "${var.ENVIRONMENT}"
    notificationdistlist= "${var.NOTIFY_LIST}"
    ownerinfo = "${var.OWNER_INFO}"
    platform = "${var.PLATFORM}"
    sponsorinfo = "${var.SPONSOR_INFO}"
  }
}


