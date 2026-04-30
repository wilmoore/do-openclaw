# 001. Use Tailscale for Private Network Access

Date: 2026-04-28

## Status

Accepted

## Context

The droplet needs to be accessible for management, but exposing it to the public internet introduces significant security risks. We need a way to access the droplet securely without public IP addresses.

## Decision

Use Tailscale to provide private network access to the droplet. The droplet will have no public IP address. All management traffic (SSH, Grafana, metrics) will flow through the Tailscale tailnet.

## Consequences

**Positive:**
- Zero public attack surface
- Encrypted traffic by default
- No need to manage VPN certificates
- Easy access from any Tailscale-enabled device

**Negative:**
- Requires Tailscale account and auth key
- Users must install Tailscale client to access the droplet
- If Tailscale goes down, management access is lost (DO console remains as fallback)

## Alternatives Considered

1. **Public IP with firewall** - Rejected: still exposes SSH to internet scanning
2. **Traditional VPN (OpenVPN/WireGuard)** - Rejected: more complex to set up and maintain
3. **Bastion host** - Rejected: adds cost and complexity

## Related

- Planning: `doc/.plan/.done/feat-ansible-openclaw-digitalocean-deployment/notes.md`