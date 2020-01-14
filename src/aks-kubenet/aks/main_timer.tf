resource "null_resource" "sleep_timer" {
  depends_on = ["azurerm_resource_group.main"
  ]
  provisioner "local-exec" {
          command = "sleep 120s "
      }
}