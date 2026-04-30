# Monitoring

## Prometheus Metrics

Metrics are exposed by **node-exporter** at:

```
http://<tailscale-ip>:9100/metrics
```

## Key Metrics

| Metric | Description |
|--------|-------------|
| `node_cpu_seconds_total` | CPU usage by mode |
| `node_memory_Active_bytes` | Memory usage |
| `container_memory_usage_bytes` | OpenClaw container memory |
| `openclaw_tasks_total` | Tasks executed (custom) |
| `openclaw_blocked_network_total` | Blocked network calls (custom) |
| `openclaw_blocked_filesystem_total` | Blocked file access (custom) |

## Custom Metrics

The OpenClaw container writes counters to `/workspace/metrics.json`:

```json
{
  "openclaw_tasks_total": 42,
  "openclaw_blocked_network_total": 3,
  "openclaw_blocked_filesystem_total": 0
}
```

node-exporter reads this via the textfile collector.

## Alerts (Prometheus format)

```yaml
groups:
  - name: openclaw
    rules:
      - alert: HighCPU
        expr: 100 - (avg by (instance) (node_cpu_seconds_total{mode="idle"}) * 100) > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage on {{ $labels.instance }}"

      - alert: HighMemory
        expr: (node_memory_Active_bytes / node_memory_MemTotal_bytes) * 100 > 75
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High memory usage on {{ $labels.instance }}"
```

## Access via Makefile

```bash
make monitor    # Prints the metrics URL
make grafana    # Prints Grafana URL and credentials
```