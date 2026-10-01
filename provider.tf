terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "3.3.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/minecraft.yml"
  config_context = "minecraft"
}
