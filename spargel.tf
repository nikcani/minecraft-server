resource "kubernetes_namespace" "spargel" {
  metadata {
    name = "spargel"
  }
}

resource "kubernetes_service" "spargel" {
  metadata {
    name      = "spargel"
    namespace = kubernetes_namespace.spargel.metadata[0].name
  }

  spec {
    type = "NodePort"

    selector = {
      name = "spargel"
    }

    port {
      port        = 25565
      target_port = 25565
    }
  }
}

resource "kubernetes_stateful_set" "spargel" {
  metadata {
    name      = "minecraft-spargel"
    namespace = kubernetes_namespace.spargel.metadata[0].name
  }

  spec {
    selector {
      match_labels = {
        name = "spargel"
      }
    }

    template {
      metadata {
        labels = {
          name = "spargel"
        }
      }
      spec {
        container {
          name  = "minecraft"
          image = "itzg/minecraft-server:java17"
          port {
            container_port = 25565
          }

          volume_mount {
            mount_path = "/data"
            name       = "spargel"
          }
        }

        volume {
          name = "spargel"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.spargel.metadata[0].name
          }
        }
      }
    }
    service_name = "spargel"
  }
}

resource "kubernetes_persistent_volume_claim" "spargel" {
  metadata {
    name      = "spargel"
    namespace = kubernetes_namespace.spargel.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "local-path"
    resources {
      requests = {
        storage = "4Gi"
      }
    }
  }
}
