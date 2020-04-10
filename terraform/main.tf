provider "azurerm" {
  version = "=2.5.0"
  features {}
}

resource "random_password" "password" {
  length = 16
  special = true
  override_special = "_%@"
}
    
resource "azurerm_resource_group" "minecraft" {
  name     = "minecraft"
  location = "West Europe"
}

resource "azurerm_storage_account" "minecraft" {
  name                     = "hashicraft"
  resource_group_name      = azurerm_resource_group.minecraft.name
  location                 = azurerm_resource_group.minecraft.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "production"
  }
}

resource "azurerm_storage_share" "minecraft_world" {
  name                 = "world"
  storage_account_name = azurerm_storage_account.minecraft.name
  quota                = 50
}

resource "azurerm_container_group" "minecraft" {
  name                = "minecraft"
  location            = azurerm_resource_group.minecraft.location
  resource_group_name = azurerm_resource_group.minecraft.name
  ip_address_type     = "public"
  dns_name_label      = "hashicraft"
  os_type             = "Linux"

  container {
    name   = "studio"
    image  = "nicholasjackson/minecraft:latest"
    cpu    = "0.5"
    memory = "1.5"

    # Main minecraft port
    ports {
      port     = 25565
      protocol = "TCP"
    }

    # RCon server port 
    ports {
      port     = 27015
      protocol = "TCP"
    }

    environment_variables = {
      MINECRAFT_MOTD="HashiCraft",
      MINECRAFT_RCONPASSWORD=random_password.password.result
    }
  
    volume {
      name = "world"
      mount_path = "/minecraft/world"
      storage_account_name = azurerm_storage_account.minecraft.name
      storage_account_key = azurerm_storage_account.minecraft.primary_access_key
      share_name = azurerm_storage_share.minecraft_world.name  
    }
  }


  tags = {
    environment = "production"
  }
}

output "fqdn" {
  value = azurerm_container_group.minecraft.fqdn
}

output "rcon_password" {
  value = random_password.password.result
}