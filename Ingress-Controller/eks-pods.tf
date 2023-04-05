resource "kubernetes_pod_v1" "app1" {
  metadata {
    name = "nexus-app1"
    labels = {
      "app" = "app1"
    }
  }

  spec {
    container {
      image = "hashicorp/http-echo"
      name  = "nexus-app1"
      args  = ["-text=Hello this is nexus app from 01 "]
    }
  }
}

resource "kubernetes_pod_v1" "app2" {
  metadata {
    name = "nexus-app2"
    labels = {
      "app" = "app2"
    }
  }

  spec {
    container {
      image = "hashicorp/http-echo"
      name  = "my-app2"
      args  = ["-text= Hello this is nexus app from 02"]
    }
  }
}