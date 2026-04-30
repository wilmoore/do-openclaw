# 002. Use Ansible for Droplet Configuration

Date: 2026-04-28

## Status

Accepted

## Context

After the droplet is provisioned by Pro CLI and cloud-init, we need a reliable way to configure Docker, OpenClaw, security hardening, and monitoring. The configuration needs to be idempotent, version-controlled, and repeatable.

## Decision

Use Ansible playbooks (triggered via `ansible-pull` from cloud-init) to configure the droplet. Playbooks live in the same `wilmoore/openclaw` repository under `ansible/`.

## Consequences

**Positive:**
- Idempotent configuration management
- Version-controlled infrastructure
- Easy to update existing droplets with `make update`
- Roles provide clear separation of concerns (docker, security, openclaw, etc.)

**Negative:**
- Requires Ansible to be installed on the droplet (added to cloud-init)
- Learning curve for users unfamiliar with Ansible
- Slight increase in initial provisioning time

## Alternatives Considered

1. **Pure cloud-init** - Rejected: not idempotent, hard to manage complex configs
2. **Bash scripts** - Rejected: error-prone, not idempotent
3. **Terraform** - Rejected: overkill for single-droplet management

## Related

- Planning: `doc/.plan/.done/feat-ansible-openclaw-digitalocean-deployment/notes.md`