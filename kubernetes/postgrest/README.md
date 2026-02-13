# PostgREST Deployment

## Prerequisites
Create the `postgrest-secret` before applying the deployment.

Option A: apply the manifest
```bash
kubectl apply -f postg-rest-secret.yaml
```

Option B: create via CLI
```bash
kubectl -n default create secret generic postgrest-secret \
  --from-literal=PGRST_DB_URI="postgres://<user>:<password>@postgres:5432/mydatabase" \
  --from-literal=PGRST_JWT_SECRET="<jwt-secret>"
```

The deployment reads:
- `PGRST_DB_URI` from `postgrest-secret`
- `PGRST_JWT_SECRET` from `postgrest-secret`
