
## Prerequisites: create postgres secret
Update `postgres-secret-user.yaml` with the desired username/password before applying, or create the secret via CLI:

```bash
kubectl -n default apply -f postgres-secret-user.yaml
```

Alternative (CLI):
```bash
kubectl -n default create secret generic postgres-secret \
  --from-literal=POSTGRES_USER="<postgres-user>" \
  --from-literal=POSTGRES_PASSWORD="<postgres-password>"
```

## connect to postgres pod and then connect locally to the db
psql -h localhost -p 5432 -U admin -d postgres
or 
psql -U admin -d postgres -h 127.0.0.1 -W
and use the password from the echo $POSTGRES_PASSWORD

## create user, passwd and db
CREATE USER emeralds WITH ENCRYPTED PASSWORD 'pass the required password for User';
CREATE DATABASE "emeralds-db" OWNER emeralds;
GRANT ALL PRIVILEGES ON DATABASE "emeralds-db" TO emeralds;

## Test connection
psql "sslmode=require host= master1-knt-platform-emeralds.northeurope.cloudapp.azure.com port=30432 dbname=emeralds-db user=emeralds"
psql -h master1-knt-platform-emeralds.northeurope.cloudapp.azure.com -p 30432 -U emeralds -d emeralds-db

## Test that ssl mode is enabled. Normally this should fail.
psql "sslmode=disable host= master1-knt-platform-emeralds.northeurope.cloudapp.azure.com port=30432 dbname=emeralds-db user=emeralds"
