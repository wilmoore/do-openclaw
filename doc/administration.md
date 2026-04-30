# Administration

## Makefile Targets

| Target | Description |
|--------|-------------|
| `make help` | Show all available targets |
| `make deploy` | Deploy a new Basic droplet (~$12/mo) |
| `make ssh` | SSH into the droplet via Tailscale |
| `make logs` | Stream OpenClaw systemd logs |
| `make monitor` | Print Prometheus metrics URL |
| `make grafana` | Print Grafana URL and credentials |
| `make status` | Show droplet status |
| `make backup` | Create a snapshot of the droplet |
| `make destroy` | Delete the droplet (prompts for confirmation) |
| `make update` | Re-run Ansible configuration |
| `make test` | Run static analysis |

## Common Tasks

### Check Droplet Status

```bash
make status
```

### View Logs

```bash
make logs
```

### Access Metrics

```bash
make monitor
# Output: http://100.x.x.x:9100/metrics
```

### Access Grafana

```bash
make grafana
# Output: http://100.x.x.x:3000
# Credentials: admin / admin
```

> **⚠️ Security Warning:** Change the default password immediately after your first login!

### Create Backup

```bash
make backup
# Creates snapshot with timestamp name
```

### Update Configuration

```bash
make update
# Re-runs ansible-pull
```

### Destroy Droplet

```bash
make destroy
# Prompts: Are you sure? [y/N]
```

## Troubleshooting

### "No Tailscale IP known"

Run `make deploy` first to create the droplet and save its IP.

### Grafana Not Reachable

1. Check Grafana is running: `make ssh` then `docker ps`
2. Ensure you're using the Tailscale IP, not a public IP

### SSH Connection Refused

Ensure your IP is in the Tailscale CIDR (`100.64.0.0/10`). The droplet has no public IP.