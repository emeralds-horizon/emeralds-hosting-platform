# Registry Access Configuration

## Description
For the K8s cluster to download the images from the github registry the registry creds should be provided as secret and the deployment manifest should refer to this secret. 
Since the creds are based on time limited tokens. The process would need to be repeated

## Configuration

1. Delete any previous secret (Checking of expiration of a the secret/token is not part of this readme.md)
```bash
kubectl delete secret emeralds-repo-secret -n default 
```

2. Create a file : dockerconfig.json with the following content
```json
{
  "auths": {
    "ghcr.io": {
      "username": "git_username",
      "password": "your-github-token",
      "auth": "'$(echo -n "git_username:your-github-token" | base64 -w 0)'"
    }
  }
}
```
The auth should be calculated manually and being copied in the file. Alternatively run

```bash
echo -n '{
  "auths": {
    "ghcr.io": {
      "username": "git_username",
      "password": "your-github-token",
      "auth": "'$(echo -n "git_username:your-github-token" | base64 -w 0)'"
    }
  }
}' > dockerconfig.json
```

3. Create the Secret Manifest File
Create a new manifest yaml file : docker-secret.yaml
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: emeralds-repo-secret
  namespace: default
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: "BASE64_ENCODED_STRING"
```
Replace BASE64_ENCODED_STRING with the base64-encoded content from Step 2.

4. Apply the Secret to Kubernetes
kubectl apply -f docker-secret.yaml -n default