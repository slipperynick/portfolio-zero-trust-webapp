# # Basic
# # ~€0.05/hour or ~€35/month
# # 10 GB, limited features
# resource "azurerm_container_registry" "badclick_acr" {
#   name                  = "badclickacr"
#   resource_group_name   = azurerm_resource_group.badclick_rg.name
#   location              = azurerm_resource_group.badclick_rg.location
#   sku                   = "Basic"
# }