job "stats" {
  datacenters = ["dc1"]
  type = "system"

  group "group" {
    count = 1

    task "task" {
      driver = "docker"
      config {
        image = "uchiru/docker-stats-exporter:v24"
        port_map { port = 3120 }
        volumes = ["/var/run/docker.sock:/var/run/docker.sock"]
      }

      resources {
        cpu = 100
        memory = 100
        network {
          mbits = 1
          port "port" {  }
        }
      }

      env {
        LABELS = "app,version"
      }

      service {
        name = "stats"
        port = "port"
        tags = ["stats"]
        check {
          type = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
