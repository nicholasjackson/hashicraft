container "minecraft" {
  image {
    name = "nicholasjackson/minecraft:latest"
  }

  volume {
    source = "./mc_server/mods"
    destination = "/minecraft/mods"
  }
  
  volume {
    source = "./mc_server/world"
    destination = "/minecraft/world"
  }

  port {
    local = 25565
    remote = 25565
    host = 25565
  }

  env {
    key = "MINECRAFT_MOTD"
    value = "HashiCraft"
  }
  
  env {
    key = "MINECRAFT_RCONPASSWORD"
    value = "password"
  }
}