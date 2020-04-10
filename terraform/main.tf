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

resource "azurerm_storage_share" "minecraft_config" {
  name                 = "config"
  storage_account_name = azurerm_storage_account.minecraft.name
  quota                = 1
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
    image  = "nicholasjackson/minecraft:v0.1.0"
    cpu    = "2"
    memory = "4"

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
      JAVA_MEMORY="4G",
      MINECRAFT_MOTD="HashiCraft",
      MINECRAFT_WHITELIST_ENABLED=true,
      MINECRAFT_RCON_ENABLED=true,
      MINECRAFT_RCON_PASSWORD=random_password.password.result,
      WORLD_BACKUP="https://github.com/nicholasjackson/hashicraft/releases/download/v0.0.0/world2.tar.gz"
      MODS_BACKUP="https://github.com/nicholasjackson/hashicraft/releases/download/v0.0.0/mods.tar.gz"
    }
  
    volume {
      name = "world"
      mount_path = "/minecraft/world"
      storage_account_name = azurerm_storage_account.minecraft.name
      storage_account_key = azurerm_storage_account.minecraft.primary_access_key
      share_name = azurerm_storage_share.minecraft_world.name  
    }
    
    volume {
      name = "config"
      mount_path = "/minecraft/config"
      storage_account_name = azurerm_storage_account.minecraft.name
      storage_account_key = azurerm_storage_account.minecraft.primary_access_key
      share_name = azurerm_storage_share.minecraft_config.name  
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