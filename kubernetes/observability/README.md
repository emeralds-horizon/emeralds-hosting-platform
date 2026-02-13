# Observability (MicroK8s Addon)

## Prerequisites
Create the Grafana admin secret before enabling the observability addon.

Option A: apply the manifest
```bash
kubectl apply -f grafana-admin-secret.yaml
```

Option B: create via CLI
```bash
kubectl -n observability create secret generic grafana-admin \
  --from-literal=admin-user=admin \
  --from-literal=admin-password='<strong-password>'
```

The `microk8s-addon-observability-values.yaml` file expects the secret name and keys:
- `grafana.admin.existingSecret: grafana-admin`
- `grafana.admin.userKey: admin-user`
- `grafana.admin.passwordKey: admin-password`
