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
  
  volume {
    source = "./server.properties"
    destination = "/minecraft/server.properties"
  }

  port {
    local = 25565
    remote = 25565
    host = 25565
  }
}