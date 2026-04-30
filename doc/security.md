# Security

## Network Isolation

- **No public IP** – Droplet is created on private networking only
- **Tailscale-only access** – All connections must come from Tailscale CIDR (`100.64.0.0/10`)
- **UFW rules**:
  - Default deny incoming
  - Allow from `100.64.0.0/10`
  - Allow SSH (22) from `100.64.0.0/10` only (optional)

## Host Hardening

Sysctl settings applied by Ansible:

```
net.ipv4.ip_forward = 0  # Set to 1 if using this droplet as a Tailscale exit node
fs.protected_regular = 1
fs.protected_fifos = 1
kernel.dmesg_restrict = 1
kernel.kptr_restrict = 2
```

> **Note:** Set `net.ipv4.ip_forward = 1` if you plan to use this droplet as a Tailscale exit node.

## Docker Sandbox

- **User namespace remapping** – `userns-remap: default`
- **No privileged containers** – Denied in daemon config
- **Read-only root filesystem** – Container runs with `--read-only`
- **Resource limits** – 1GB RAM, 1 CPU (Basic droplet)
- **tmpfs for workspace** – `/workspace` mounted as tmpfs (writable)

## Tailscale

- Droplet joins your tailnet via auth key (injected at deploy time)
- No exit node enabled by default
- You can enable it manually if needed:
  ```bash
  sudo tailscale up --advertise-exit-node
  ```
  Then approve in the Tailscale admin console.

## Secrets

Secrets are retrieved at runtime via `security(1)`:
- `TAILSCALE_AUTHKEY` – Only injected into cloud-init, never persisted to disk
- `DO_TOKEN` – Used by pro CLI, not stored on droplet

## Log Security

- All agent actions logged to `/var/log/openclaw/agent.log`
- Blocked actions logged with "BLOCKED" prefix
- Log files owned by root, non-writable by container