# Deployment

## Droplet Sizes

| Size | Slug | vCPU | RAM | SSD | Monthly Cost |
|------|------|-----|-----|-----|--------------|
| Basic | `s-2vcpu-2gb` | 2 | 2GiB | 60GB | ~$12 |
| CPU-Optimized | `s-2vcpu-4gb` | 2 | 4GiB | 80GB | ~$24 |
| General-Purpose | `s-4vcpu-8gb` | 4 | 8GiB | 160GB | ~$48 |

Default is **Basic** (`s-2vcpu-2gb`).

## Override Size

```bash
make deploy DEPLOY_FLAGS="--size s-4vcpu-8gb --region fra1"
```

## Environment Variables (via security(1) or environment)

The Makefile retrieves these at runtime. On macOS, use Keychain:

```bash
security add-generic-password -s "tailscale-authkey" -a "$USER" -w "tskey-xxx"
security add-generic-password -s "do-token" -a "$USER" -w "do-token"
security add-generic-password -s "do-ssh-key-id" -a "$USER" -w "key-id"
```

On Linux/Windows, use environment variables:

```bash
export TAILSCALE_AUTHKEY="tskey-xxx"
export DO_TOKEN="do-token"
export SSH_KEY_ID="key-id"
```

> **Note:** `security` is built-in on macOS (no install needed). For Linux, consider `pass` or a `.env` file with `direnv`.

## Cloud-Init Flow

1. Install Tailscale and bring droplet into your tailnet
2. Install Docker and enable user namespace remapping
3. Install Ansible
4. Run `ansible-pull` to fetch and execute the playbook

## Ansible Configuration

The playbook (`ansible/site.yml`) runs these roles:

- **docker** – Install Docker, configure daemon
- **security** – UFW firewall, sysctl hardening
- **openclaw** – Build and run OpenClaw container
- **observability** – node-exporter, logging
- **systemd** – Service unit for OpenClaw
- **grafana** – Dashboard container (optional)

## Outbound Allowlist

Default allowed hosts: `github.com,api.openai.com,api.anthropic.com`

To modify, edit `ansible/roles/openclaw/defaults/main.yml`:

```yaml
allowlist: "github.com,api.openai.com,api.anthropic.com,your-custom-host.com"
```

## Manual Update

To re-run Ansible on an existing droplet:

```bash
make update
```

This pulls the latest playbook from the repository and applies it.