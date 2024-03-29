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
      node_port   = 30000
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

          env {
            name  = "VERSION"
            value = "1.19.2"
          }
          env {
            name  = "EULA"
            value = "TRUE"
          }
          env {
            name  = "SEED"
            value = "spargel"
          }
          env {
            name  = "TYPE"
            value = "FORGE"
          }
          env {
            name  = "MEMORY"
            value = "24G"
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

resource "kubernetes_storage_class" "spargel" {
  metadata {
    name = "spargel"
  }
  storage_provisioner    = "kubernetes.io/no-provisioner"
  allow_volume_expansion = true
}

resource "kubernetes_persistent_volume" "spargel" {
  metadata {
    name = "spargel"
  }

  spec {
    storage_class_name = "spargel"
    access_modes       = ["ReadWriteOnce"]
    capacity           = {
      storage = "8Gi"
    }
    persistent_volume_source {
      host_path {
        path = "/root/volume/spargel"
        type = "DirectoryOrCreate"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "spargel" {
  wait_until_bound = false
  metadata {
    name      = "spargel"
    namespace = kubernetes_namespace.spargel.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "spargel"
    resources {
      requests = {
        storage = "8Gi"
      }
    }
  }
}
