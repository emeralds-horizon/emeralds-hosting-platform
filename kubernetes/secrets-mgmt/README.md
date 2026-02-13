# Description  
Use Bitname Sealed secret for securely storing secrets in GIT. 

The solution was selected as it is more dev friendly in the sense that the devs may encrypt their own secrets and store the into the git repository without the need for any central mangements tool/admin - as in the case of hashicorp vault. 

## Installation 
1. kubectl apply -f controller.yaml

NOTE: the latest controller can be found in https://github.com/bitnami-labs/sealed-secrets/releases/latest/download/controller.yaml
1.2. Verify installation
kubectl get pods -n kube-system | grep sealed-secrets

2. Install kubeseal CLI on Your Local Machine
For Linux:

```bash
KUBESEAL_VERSION='0.28.0'
curl -OL "https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION:?}/kubeseal-${KUBESEAL_VERSION:?}-linux-amd64.tar.gz"
tar -xvzf kubeseal-${KUBESEAL_VERSION:?}-linux-amd64.tar.gz kubeseal
sudo install -m 755 kubeseal /usr/local/bin/kubeseal
```
more info at [installation](https://github.com/bitnami-labs/sealed-secrets?tab=readme-ov-file#installation)


## Encrypt
Encrypt the db-secret.yaml file using kubeseal:

```bash
kubeseal --format=yaml < db-secret.yaml > sealed-db-secret.yaml
```

## Creation of the db-secret.yaml file
The file should be created as following

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-credentials
data:
  DB_PASSWORD: <base64 encoded password>
  DB_USER: <base64 encoded username>
```
The two parameters should be created as follows
```bash
echo -n "user" | base64 
echo -n "password" | base64
```

NOTE: The echo -n flag is very important as otherwise the encoded string will contain a new line!!!
NOTE: The kubernetes secrets file should NOT BE PUSHED TO REGISTRY!!!!
