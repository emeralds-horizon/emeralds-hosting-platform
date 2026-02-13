# Description
Apache kafka is a well established message broker. 

It is required by many Emeralds Services as it allows the use of data streams in large quanitites for effective Data Pipelines

## Installation
a.Ensure helm is installed.

b. Add Bitmnami repo
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

c. Download latest values.yaml (Optional)
```bash
helm show values bitnami/kafka > values.yaml
```

d. Make any necessary modifications
...to enable, namespace ,external access (NodePort, exposed port), enable tls (Certs), sasl and user authentication.

e. Deploy
```bash
helm install emeralds-kafka bitnami/kafka -f kubernetes/emeralds-kafka/values.yaml
```

f. Firewall
Important note, User may open all the external broker's ports for successful communication of remote clients to the Kafka Cluster