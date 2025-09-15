resource "azurerm_log_analytics_workspace" "badclick_logs" {
  name                = "badclickorg-law"
  location            = azurerm_resource_group.badclick_org_rg.location
  resource_group_name = azurerm_resource_group.badclick_org_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    environment = "Production"
  }
}