provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = "~>2.4.0"

  subscription_id = "07434f58-9ca2-4a76-b72f-e615836f2bb4"
  client_id       = "6f9d1404-8051-464b-a6bf-366de7caeb4f"
  client_secret   = var.client_secret
  tenant_id       = "a758a091-0414-46bd-9e89-e5139d903d34"

  features {}
}
