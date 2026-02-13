# Emeralds Hosting Services

## Required Configuration Parameters
This project expects the following parameters to be set before deployment.
You can generate local random credentials and SSH keys using `scripts/generate-local-secrets.sh` (writes to `.secrets/`).

- Repository credentials (Ansible):
  - `EMERALDS_REPO_USERNAME` and `EMERALDS_REPO_TOKEN` in `.env` (see `.env.template`).
  - Consumed by `ansible/host_vars/master1/repo.yaml`.

- Proxmox cloud-init (OpenTofu):
  - `ci_password` and `ssh_keys` variables (via `TF_VAR_*` or `*.tfvars`).
  - Consumed by `cloud-resources/proxmox/main.tf`.

- Grafana admin (Monitoring):
  - Secret `grafana-admin` with keys `admin-user` and `admin-password`.
  - Used by `kubernetes/monitoring/kube-prometheus-values.yaml`.

- Grafana admin (Observability addon):
  - Secret `grafana-admin` in `observability` namespace with keys `admin-user` and `admin-password`.
  - Used by `kubernetes/observability/microk8s-addon-observability-values.yaml`.

- PostgREST:
  - Secret `postgrest-secret` with `PGRST_DB_URI` and `PGRST_JWT_SECRET`.
  - Used by `kubernetes/postgrest/postg-rest-deployment.yaml`.

- Postgres:
  - Secret `postgres-secret` with `POSTGRES_USER` and `POSTGRES_PASSWORD`.
  - Used by `kubernetes/emeralds-postgres/templates/postgres-secret-user.yaml`.
