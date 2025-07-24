provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "badclick_org_rg" {
  name     = "badclick-infrastructure-rg"
  location = "West Europe"

  tags = {
    environment = "dev"
    owner       = "Nicholas Harripersad"
  }
}