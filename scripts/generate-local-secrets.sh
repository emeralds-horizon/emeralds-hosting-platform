#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SECRETS_DIR="${ROOT_DIR}/.secrets"
SSH_KEY_DIR="${ROOT_DIR}/ansible/emeralds_user"
SSH_KEY_PATH="${SSH_KEY_DIR}/ssh"

mkdir -p "${SECRETS_DIR}" "${SSH_KEY_DIR}"

rand_b64() {
  if command -v openssl >/dev/null 2>&1; then
    openssl rand -base64 24 | tr -d '\n'
  else
    # Fallback if openssl is unavailable
    head -c 32 /dev/urandom | base64 | tr -d '\n'
  fi
}

if [[ ! -f "${SSH_KEY_PATH}" ]]; then
  ssh-keygen -t ed25519 -f "${SSH_KEY_PATH}" -C "emeralds-admin" -N ""
fi

GRAFANA_PASSWORD="$(rand_b64)"
POSTGRES_PASSWORD="$(rand_b64)"
PGRST_JWT_SECRET="$(rand_b64)"
PGRST_DB_PASSWORD="$(rand_b64)"
PGRST_DB_URI="postgres://emeralds-admin:${PGRST_DB_PASSWORD}@postgres:5432/mydatabase"

cat <<EOF2 > "${SECRETS_DIR}/grafana-admin-monitoring.yaml"
apiVersion: v1
kind: Secret
metadata:
  name: grafana-admin
  namespace: monitoring
type: Opaque
stringData:
  admin-user: emeralds-admin
  admin-password: ${GRAFANA_PASSWORD}
EOF2

cat <<EOF2 > "${SECRETS_DIR}/grafana-admin-observability.yaml"
apiVersion: v1
kind: Secret
metadata:
  name: grafana-admin
  namespace: observability
type: Opaque
stringData:
  admin-user: emeralds-admin
  admin-password: ${GRAFANA_PASSWORD}
EOF2

cat <<EOF2 > "${SECRETS_DIR}/postgres-secret.yaml"
apiVersion: v1
kind: Secret
metadata:
  name: postgres-secret
type: Opaque
stringData:
  POSTGRES_USER: emeralds-admin
  POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
EOF2

cat <<EOF2 > "${SECRETS_DIR}/postgrest-secret.yaml"
apiVersion: v1
kind: Secret
metadata:
  name: postgrest-secret
type: Opaque
stringData:
  PGRST_DB_URI: "${PGRST_DB_URI}"
  PGRST_JWT_SECRET: "${PGRST_JWT_SECRET}"
EOF2

cat <<EOF2 > "${SECRETS_DIR}/summary.txt"
SSH key:
  ${SSH_KEY_PATH}
  ${SSH_KEY_PATH}.pub

Grafana admin user:
  emeralds-admin

Postgres user:
  emeralds-admin

PostgREST DB URI:
  ${PGRST_DB_URI}
EOF2

chmod 600 "${SSH_KEY_PATH}" "${SSH_KEY_PATH}.pub" || true

cat <<EOF2
Generated local secrets in ${SECRETS_DIR}
- grafana-admin-monitoring.yaml
- grafana-admin-observability.yaml
- postgres-secret.yaml
- postgrest-secret.yaml

Apply with:
  kubectl apply -f ${SECRETS_DIR}/grafana-admin-monitoring.yaml
  kubectl apply -f ${SECRETS_DIR}/grafana-admin-observability.yaml
  kubectl apply -f ${SECRETS_DIR}/postgres-secret.yaml
  kubectl apply -f ${SECRETS_DIR}/postgrest-secret.yaml
EOF2
