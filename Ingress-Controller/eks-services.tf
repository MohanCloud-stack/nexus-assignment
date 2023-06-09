resource "kubernetes_service_v1" "app1_service" {
  metadata {
    name = "nexus-app1-service01"
  }
  spec {
    selector = {
      app = kubernetes_pod_v1.app1.metadata.0.labels.app
    }
    port {
      port = 5678
    }
  }
}

resource "kubernetes_service_v1" "app2_service" {
  metadata {
    name = "nexus-app2-service02"
  }
  spec {
    selector = {
      app = kubernetes_pod_v1.app2.metadata.0.labels.app
    }
    port {
      port = 5678
    }
  }
}