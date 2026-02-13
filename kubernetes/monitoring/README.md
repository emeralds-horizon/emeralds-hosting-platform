# Setup Monitoring for resources & Centralized Logging service.


## Configuration Steps 

- enable Help if not enabled

- Add Helm Repositories
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

No need to seperately add : helm repo add grafana https://grafana.github.io/helm-charts

- Enable metrics if not enabled. This command should be run from the localhost machine. Therefore it is best to be added in 

```bash
microk8s enable metrics-server
```

- Create a separated namespace
kubectl create namespace monitoring

- Create the Grafana admin secret (required)
Option A: apply the manifest
```bash
kubectl apply -f grafana-admin-secret.yaml
```

Option B: create via CLI
```bash
kubectl -n monitoring create secret generic grafana-admin \
  --from-literal=admin-user=admin \
  --from-literal=admin-password='<strong-password>'
```

- Modify the values.yaml if necessary
Usually the following values needs to be updated
        - grafana.admin.existingSecret (default: grafana-admin)
        - grafana.ingress.hosts
        - prometheus.ingress.hosts
        - prometheus.prometheusSpec.externalUrl
        - prometheus.prometheusSpec.storageSpec..storage sizes

- Deploy the resources

```bash
helm install monitoring prometheus-community/kube-prometheus-stack -n monitoring -f kube-prometheus-values.yaml
```

as an alternative you make run 

```bash
make deploy
```

- Verify Installation

```bash
helm list -n monitoring
kubectl get pods -n monitoring
kubectl get svc -n monitoring
```
