provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "badclick-infrastructure-rg"
  location = "West Europe"

  tags = {
    environment = "dev"
    owner       = "Nicholas Harripersad"
  }
}