job "demo-app" {
  datacenters = ["dc1"]
  type = "service"

  group "web" {
    count = 8

    update {
      max_parallel = 3
      min_healthy_time = "20s"
    }

    task "main" {
      driver = "docker"

      config {
        image = "avakhov/demo-app:v1"
        port_map { port = 9292 }
        labels {
          app = "demo-app"
          version = "v1"
        }
      }

      resources {
        cpu    = 100
        memory = 300
        network {
          mbits = 1
          port "port" { }
        }
      }

      service {
        port = "port"
        tags = ["urlprefix-demo-app.__MAINIP__.xip.io:9999/"]
        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
