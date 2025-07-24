resource "azurerm_kubernetes_cluster" "badclick_org_aks" {
  name                = "badclick-org-aks"
  location            = azurerm_resource_group.badclick_org_rg.location
  resource_group_name = azurerm_resource_group.badclick_org_rg.name
  dns_prefix          = "badclickorgaks"

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_B2s"
    vnet_subnet_id = azurerm_subnet.badclick_org_subnet1.id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }

  network_profile {
    network_plugin = "azure"
  }

  role_based_access_control_enabled = true
  kubernetes_version                = "1.29.2"
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.badclick_org_aks.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.badclick_org_aks.kube_config_raw

  sensitive = true
}