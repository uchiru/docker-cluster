job "prometheus" {
  datacenters = ["dc1"]
  type = "service"
  
  constraint {
    attribute = "${node.unique.name}"
    operator = "="
    value = "node01"
  }

  group "prometheus" {
    count = 1

    task "main" {
      driver = "docker"

      template {
        data = <<EOF
          global:
            scrape_interval:     10s
            evaluation_interval: 10s
          scrape_configs:
            - job_name: all
              consul_sd_configs:
                - server: 192.168.99.4:8500
                  services: [node_exporter, stats]
              relabel_configs:
                - source_labels: [__meta_consul_node]
                  target_label: instance
                - source_labels: [__meta_consul_service]
                  target_label: service_name
        EOF
        destination   = "local/config.yml"
      }

      config {
        image = "prom/prometheus"
        command = "--config.file=/local/config.yml"
        port_map { port = 9090 }
      }

      resources {
        cpu    = 100
        memory = 300
        network {
          mbits = 1
          port "port" { 
            static = 9090
          }
        }
      }

      service {
        port = "port"
        tags = ["urlprefix-prometheus.__MAINIP__.xip.io:9999/"]
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
