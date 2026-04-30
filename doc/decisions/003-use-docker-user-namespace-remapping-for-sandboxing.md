# 003. Use Docker User Namespace Remapping for Sandboxing

Date: 2026-04-28

## Status

Accepted

## Context

We need to run OpenClaw agents in containers while minimizing the risk of container escape. The default Docker setup runs containers as root, which becomes a security issue if a container is compromised.

## Decision

Enable Docker user namespace remapping (`userns-remap: default`) in the daemon configuration. This maps the container root user to an unprivileged user on the host.

## Consequences

**Positive:**
- Container root is not host root
- Limits damage from container breakout
- Follows principle of least privilege

**Negative:**
- Some images may not work with remapping (OpenClaw image must be compatible)
- Slight increase in disk usage (remapped UIDs)

## Alternatives Considered

1. **Rootless Docker** - Rejected: more complex setup, less documentation
2. **No remapping** - Rejected: too risky for internet-facing agents
3. **VM isolation** - Rejected: too heavy for $12/mo droplet

## Related

- Planning: `doc/.plan/.done/feat-ansible-openclaw-digitalocean-deployment/notes.md`