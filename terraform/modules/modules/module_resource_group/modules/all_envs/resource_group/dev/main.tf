# Create the Azure Resource Group
resource "azurerm_resource_group" "main" {
  count = var.enabled_for_deployment ? 1 : 0
  name                = var.resource_group_name
  location            = var.resource_group_location
  tags = var.resource_group_tags
  provider = azurerm.dev
}
