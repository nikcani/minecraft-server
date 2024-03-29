terraform {
  cloud {
    organization = "minecraft-server"

    workspaces {
      name = "minecraft"
    }
  }
}
