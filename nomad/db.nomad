job "db" {
  datacenters = ["dc1"]
  type = "service"

  constraint {
    attribute = "${node.unique.name}"
    operator = "="
    value = "node01"
  }

  group "db" {
    count = 1

    task "main" {
      driver = "docker"

      env {
        POSTGRES_USER = "redmine"
        POSTGRES_PASSWORD = "password"
      }

      config {
        image = "postgres:10"
        port_map { port = 5432 }
        volumes = [
          "/opt/redmine-db:/var/lib/postgresql/data"
        ]
      }

      resources {
        cpu    = 100
        memory = 300
        network {
          mbits = 1
          port "port" {
            static = 5432
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
