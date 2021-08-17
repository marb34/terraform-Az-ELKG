resource "azurerm_storage_account" "monitorblob" {
  name                     = "monitorblob2"
  resource_group_name      = azurerm_resource_group.Terraform-test.name
  location                 = azurerm_resource_group.Terraform-test.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}