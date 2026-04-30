# Getting Started

## Prerequisites

1. **Tailscale account** – Generate an auth key at https://login.tailscale.com/admin/settings/authkeys
2. **DigitalOcean account** – Generate an API token at https://cloud.digitalocean.com/account/api/tokens
3. **SSH key added to DO** – Add your public key at https://cloud.digitalocean.com/account/security
4. **pro CLI** – Install from https://github.com/wilmoore/pro
5. **Shell with environment** – Export the following variables:

```bash
# macOS: use Keychain
security add-generic-password -s "tailscale-authkey" -a "$USER" -w "tskey-xxxxxxxxxxxxxxxxxxxxxxxx"
security add-generic-password -s "do-token" -a "$USER" -w "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
security add-generic-password -s "do-ssh-key-id" -a "$USER" -w "xxxxxxxxxx"

# Linux/Windows: use environment variables
export TAILSCALE_AUTHKEY="tskey-xxxxxxxxxxxxxxxxxxxxxxxx"
export DO_TOKEN="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
export SSH_KEY_ID="xxxxxxxxxx"
```

> **Note:** `security` is a built-in macOS command (no `brew install` needed). For Linux/Windows, use environment variables as shown above.

## Deploy

```bash
make deploy
```

This creates a Basic droplet (`s-2vcpu-2gb`, ~$12/mo) behind Tailscale. The deployment prints the Tailscale IP when complete.

## Access

After deployment, the Tailscale IP is saved in `.tailscale_ip`. To connect:

```bash
make ssh        # SSH into the droplet
make logs       # Stream OpenClaw logs
make monitor    # Print Prometheus metrics URL
make grafana    # Print Grafana URL and credentials
```

## Next Steps

- See [deployment.md](deployment.md) for size options and customization
- See [monitoring.md](monitoring.md) for metrics and Grafana
- See [administration.md](administration.md) for all Makefile targets