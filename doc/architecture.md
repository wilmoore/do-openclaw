# Architecture

## High-Level Diagram

```
User (Tailscale-enabled device)
  └─> Tailscale network (tailnet, 100.64.0.0/10)
       └─> DigitalOcean Droplet (private IP only, no public access)
            ├─ cloud-init
            │   ├─ Install Tailscale
            │   ├─ Install Docker
            │   └─ Run ansible-pull
            ├─ Ansible Playbook
            │   ├─ Docker role (runtime)
            │   ├─ OpenClaw role (app container)
            │   ├─ Security role (UFW, sysctl)
            │   ├─ Observability role (node-exporter, logs)
            │   ├─ Systemd role (service unit)
            │   └─ Grafana role (visualization)
            └─ Systemd Services
                 ├─ openclaw (container)
                 ├─ node-exporter (metrics)
                 └─ grafana (dashboard)
```

## Network Security

- **No public IP** – Droplet is created without a public IP
- **Tailscale-only access** – Only connections from Tailscale CIDR (`100.64.0.0/10`) are allowed
- **UFW** – Default deny incoming, allow from Tailscale only
- **Exposed Services:**
  - Port 22/tcp – SSH (Tailscale only)
  - Port 3000/tcp – Grafana (Tailscale only, basic auth)
  - Port 9100/tcp – node-exporter (Tailscale only)

## Authentication

- **Grafana** – Default `admin:admin`, change on first login
- **SSH** – Key-based authentication (Tailscale only)

## Container Sandboxing

- Docker user-namespace remapping
- Read-only root filesystem
- Resource limits (1GB RAM, 1 CPU by default)
- No privileged containers
- Separate bridge network for OpenClaw

## Observability

- **node-exporter** – Host metrics at `:9100/metrics`
- **Custom counters** – `/workspace/metrics.json` read by textfile collector
- **Logging** – `/var/log/openclaw/agent.log` with 7-day rotation