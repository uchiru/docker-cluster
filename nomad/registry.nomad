job "registry" {
  datacenters = ["dc1"]
  type = "service"

  constraint {
    attribute = "${node.unique.name}"
    operator = "="
    value = "node01"
  }

  group "registry" {
    count = 1

    task "main" {
      driver = "docker"

      config {
        image = "registry:2"
        port_map { port = 5000 }
      }

      resources {
        cpu    = 100
        memory = 300
        network {
          mbits = 1
          port "port" {
            static = 5000
          }
        }
      }

      service {
        port = "port"
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
