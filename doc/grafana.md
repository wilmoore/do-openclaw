# Grafana

Grafana provides visual dashboards for monitoring your OpenClaw deployment. It's optional but included by default.

## URL and Credentials

After deployment:

- **URL:** `http://<tailscale-ip>:3000`
- **Username:** `admin`
- **Password:** `admin`

> **⚠️ Security Warning:** Change the default password immediately after first login!

Print with:

```bash
make grafana
```

## Default Dashboard

The Ansible playbook provisions a default dashboard showing:

- CPU usage (from node-exporter)
- Memory usage (from node-exporter)
- OpenClaw tasks executed (custom metrics)
- Blocked actions (custom metrics)

## Importing Dashboards

1. Log into Grafana at `http://<tailscale-ip>:3000`
2. Go to **Dashboards → Import**
3. Upload a JSON file from `docker/grafana/dashboards/`
4. Or paste JSON directly

## Sample Dashboard JSON

Default dashboard is stored in `docker/grafana/dashboards/openclaw-default.json`.

## Changing Admin Password

1. Log into Grafana
2. Go to **Configuration → Users**
3. Click "admin" and update password

Or via API:

```bash
curl -X PUT -H "Content-Type: application/json" \
  -d '{"password":"newpassword"}' \
  http://admin:admin@<tailscale-ip>:3000/api/user/1
```

## Disabling Grafana

If you don't need Grafana, disable it in the Ansible playbook by removing the `grafana` role from `site.yml`.