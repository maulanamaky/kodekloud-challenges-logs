resource "kubernetes_deployment_v1" "frontend" {
  metadata {
    name = "frontend"
    labels = {
      name = "frontend"
    }
  }

  spec {
    replicas = 4

    selector {
      match_labels = {
        name = "webapp"
      }
    }

    template {
      metadata {
        labels = {
          name = "webapp"
        }
      }

      spec {
        container {
          image = "kodekloud/webapp-color:v1"
          name  = "simple-webapp"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "webapp-service" {
  metadata {
    name = "webapp-service"
  }
  spec {
    selector = {
      name = kubernetes_deployment_v1.frontend.spec.0.template.0.metadata.0.labels.name
    }
    port {
      port        = 8080
      target_port = 8080
      node_port   = 30080
    }

    type = "NodePort"
  }
}
