# Kubernetes 

## Table of Contents 

- [Commands](#commands)

First an ingress service needs to be deployed via the following command:

```bash
kubectl apply -f ./ingress-manifests/ingress-service.yaml
```

Next, a cluster issuer needs to be deployed 

```bash
kubectl apply -f ./cert-manager-manifests/production-issuer.yaml
```

Last, the ingress resource for path routing needs to be deployed as well

```bash
kubectl apply -f ./ingress-manifests/latest-app-ingress.yaml
```