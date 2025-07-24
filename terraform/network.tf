resource "azurerm_network_security_group" "badclick_org_nsg" {
  name                = "badclick_org_nsg"
  location            = azurerm_resource_group.badclick_org_rg.location
  resource_group_name = azurerm_resource_group.badclick_org_rg.name
}

resource "azurerm_network_security_rule" "badclick_org_allow_https" {
  name                        = "AllowHTTPS"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.badclick_org_rg.name
  network_security_group_name = azurerm_network_security_group.badclick_org_nsg.name
}

resource "azurerm_network_security_rule" "badclick_org_allow_k8s_api" {
  name                        = "AllowK8sAPI"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "6443"
  source_address_prefix       = "85.223.72.147/32" # Allow from only trusted sources
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.badclick_org_rg.name
  network_security_group_name = azurerm_network_security_group.badclick_org_nsg.name
}

resource "azurerm_network_security_rule" "badclick_org_allow_dns" {
  name                        = "AllowDNS"
  priority                    = 120
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.badclick_org_rg.name
  network_security_group_name = azurerm_network_security_group.badclick_org_nsg.name
}

resource "azurerm_virtual_network" "badclick_org_vnet" {
  name                = "badclick_org_vnet"
  location            = azurerm_resource_group.badclick_org_rg.location
  resource_group_name = azurerm_resource_group.badclick_org_rg.name
  address_space       = ["10.0.0.0/16"]
  #   dns_servers         = ["10.0.0.4", "10.0.0.5"]

  tags = {
    environment = "Production"
  }
}

resource "azurerm_subnet" "badclick_org_subnet1" {
  name                 = "badclick_org_subnet1"
  resource_group_name  = azurerm_resource_group.badclick_org_rg.name
  virtual_network_name = azurerm_virtual_network.badclick_org_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "badclick_org_subnet2" {
  name                 = "badclick_org_subnet2"
  resource_group_name  = azurerm_resource_group.badclick_org_rg.name
  virtual_network_name = azurerm_virtual_network.badclick_org_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}