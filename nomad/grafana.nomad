job "grafana" {
  datacenters = ["dc1"]
  type = "service"

  group "grafana" {
    count = 1

    task "main" {
      driver = "docker"

      template {
        data = <<EOF
          datasources:
            - name: Prometheus
              type: prometheus
              access: proxy
              url: http://prometheus.__MAINIP__.xip.io:9999
              is_default: true
        EOF
        destination   = "local/provisioning/datasources/prometheus.yml"
      }

      template {
        data = <<EOF
          - name: 'default'
            org_id: 1
            folder: ''
            type: file
            options:
              folder: /local/provisioning/dashboards/src
        EOF
        destination   = "local/provisioning/dashboards/provider.yml"
      }

      template {
        data = <<EOF
          {
            "title": "All",
            "uid": "all",
            "time": {"from": "now-5m", "to": "now"},
            "timepicker": {
              "refresh_intervals": ["5s", "10s", "30s"],
              "time_options": ["5m", "15m", "1h", "6h", "12h", "24h"]
            },
            "refresh": "5s",
            "panels": [
              {
                "title": "CPU",
                "type": "graph",
                "fill": 8,
                "lines": true,
                "linewidth": 2,
                "stack": true,
                "gridPos": {"x": 0, "y": 0, "w": 8, "h": 6},
                "legend": {"show": false},
                "targets": [
                  {
                    "expr": "sum(1 - rate(node_cpu{mode=\"idle\"}[1m]))",
                    "legendFormat": "used"
                  },
                  {
                    "expr": "sum(rate(node_cpu{mode=\"idle\"}[1m]))",
                    "legendFormat": "idle"
                  }
                ],
                "aliasColors": {"idle": "#7eb26d", "used": "#6d1f62"},
                "tooltip": {"shared": true, "sort": 2},
                "yaxes": [
                  {"format": "short", "max": null, "min": 0, "show": true},
                  {"show": false}
                ]
              },
              {
                "title": "Memory",
                "type": "graph",
                "fill": 8,
                "lines": true,
                "linewidth": 2,
                "stack": true,
                "gridPos": {"x": 8, "y": 0, "w": 8, "h": 6},
                "legend": {"show": false},
                "targets": [
                  {
                    "expr": "sum(node_memory_MemTotal - node_memory_Cached - node_memory_Buffers - node_memory_MemFree)",
                    "legendFormat": "used"
                  },
                  {
                    "expr": "sum(node_memory_Buffers)",
                    "legendFormat": "buffers"
                  },
                  {
                    "expr": "sum(node_memory_Cached)",
                    "legendFormat": "cached"
                  },
                  {
                    "expr": "sum(node_memory_MemFree)",
                    "legendFormat": "free"
                  }
                ],
                "aliasColors": {"buffers": "#6ed0e0", "cached": "#0a437c", "free": "#508642", "used": "#bf1b00"},
                "tooltip": {"shared": true, "sort": 2},
                "yaxes": [
                  {"format": "bytes", "max": null, "min": 0, "show": true},
                  {"show": false}
                ]
              },
              {
                "title": "Disks",
                "type": "graph",
                "fill": 8,
                "lines": true,
                "linewidth": 2,
                "stack": true,
                "gridPos": {"x": 16, "y": 0, "w": 8, "h": 6},
                "legend": {"show": false},
                "targets": [
                  {
                    "expr": "sum(node_filesystem_size{mountpoint=\"/\"} - node_filesystem_avail{mountpoint=\"/\"})",
                    "legendFormat": "used"
                  },
                  {
                    "expr": "sum(node_filesystem_avail{mountpoint=\"/\"})",
                    "legendFormat": "free"
                  }
                ],
                "aliasColors": {"free": "#508642", "used": "#bf1b00"},
                "tooltip": {"shared": true, "sort": 2},
                "yaxes": [
                  {"format": "bytes", "max": null, "min": null, "show": true},
                  {"show": false}
                ]
              },

              {
                "title": "CPU",
                "type": "graph",
                "fill": 0,
                "lines": true,
                "linewidth": 2,
                "stack": false,
                "gridPos": {"x": 0, "y": 6, "w": 8, "h": 6},
                "legend": {"show": false},
                "targets": [
                  {
                    "expr": "sum(1 - rate(node_cpu{mode=\"idle\"}[1m])) by (instance)",
                    "legendFormat": "{{instance}}"
                  }
                ],
                "tooltip": {"shared": true, "sort": 2},
                "yaxes": [
                  {"format": "short", "max": null, "min": 0, "show": true},
                  {"show": false}
                ]
              },
              {
                "title": "Eth0, in",
                "type": "graph",
                "fill": 0,
                "lines": true,
                "linewidth": 2,
                "stack": false,
                "gridPos": {"x": 8, "y": 6, "w": 8, "h": 6},
                "legend": {"show": false},
                "targets": [
                  {
                    "expr": "sum(rate(node_network_receive_bytes{device=\"eth0\"}[1m])) by (instance)",
                    "legendFormat": "{{instance}}"
                  }
                ],
                "tooltip": {"shared": true, "sort": 2},
                "yaxes": [
                  {"format": "Bps", "max": null, "min": 0, "show": true},
                  {"show": false}
                ]
              },
              {
                "title": "Eth0, out",
                "type": "graph",
                "fill": 0,
                "lines": true,
                "linewidth": 2,
                "stack": false,
                "gridPos": {"x": 16, "y": 6, "w": 8, "h": 6},
                "legend": {"show": false},
                "targets": [
                  {
                    "expr": "sum(rate(node_network_transmit_bytes{device=\"eth0\"}[1m])) by (instance)",
                    "legendFormat": "{{instance}}"
                  }
                ],
                "tooltip": {"shared": true, "sort": 2},
                "yaxes": [
                  {"format": "Bps", "max": null, "min": 0, "show": true},
                  {"show": false}
                ]
              }
            ]
          }
        EOF
        destination = "local/provisioning/dashboards/src/all.json"
        left_delimiter = "<<"
        right_delimiter = ">>"
      }

      template {
        data = <<EOF
          {
            "title": "Demo App",
            "uid": "demo",
            "time": {"from": "now-5m", "to": "now"},
            "timepicker": {
              "refresh_intervals": ["5s", "10s", "30s"],
              "time_options": ["5m", "15m", "1h", "6h", "12h", "24h"]
            },
            "refresh": "5s",
            "panels": [
              {
                "title": "Demo App",
                "type": "graph",
                "fill": 8,
                "lines": true,
                "linewidth": 2,
                "stack": true,
                "gridPos": {"x": 0, "y": 0, "w": 12, "h": 6},
                "legend": {"show": false},
                "targets": [
                  {
                    "expr": "sum(docker_up{label_app=\"demo-app\"}) by (label_version)"
                  }
                ],
                "tooltip": {"shared": true, "sort": 2},
                "yaxes": [
                  {"format": "short", "max": null, "min": 0, "show": true},
                  {"show": false}
                ]
              }
            ]
          }
        EOF
        destination = "local/provisioning/dashboards/src/demo.json"
        left_delimiter = "<<"
        right_delimiter = ">>"
      }

      env {
        GF_AUTH_ANONYMOUS_ENABLED = "true"
        GF_PATHS_PROVISIONING     = "/local/provisioning"
      }

      config {
        image = "grafana/grafana:5.0.0"
        port_map { port = 3000 }
      }

      resources {
        cpu    = 100
        memory = 300
        network {
          mbits = 1
          port "port" {
            static = 3000
          }
        }
      }

      service {
        port = "port"
        tags = ["urlprefix-grafana.__MAINIP__.xip.io:9999/"]
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
