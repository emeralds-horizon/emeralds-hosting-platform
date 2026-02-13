
# Emeralds Hosting Services

## Table of Contents
- [Description](#description)
- [Configuration](#configuration)
- [Prerequisites](#prerequisites)
- [Commands](#commands)


## Description
The Ansible scripts are used for the configuration of the Kubernetes cluster. <br>
The target hosts of the ansible playbooks are intended to target three hosts deployed on an Azure network.<br>
Hosts and environmental variables are specified in the `inventory.yaml`<br>

Those playbooks are responsible for installing the following in the hosts 
1. a MicroK8s cluster
2. a KubeEdge 
3. an argocd operator synced with the private repository located at: https://github.com/emeralds-horizon/. The private repos contains the manifests for deploying the emeralds service on the cluster.
4. The installation of the `cert-manager` on the deployed MicroK8s cluster ensures that every service can be accessed via HTTPS from outside.
5. The deployment of a Kubernetes Ingress Resource

## Configuration

### Ansible Inventory  and configuation files
This is the basic configuration file that allows the ansible to identify and target the servers that will host the solution. <br>
The current ${REPO_ROOT}/ansible/inventory.yaml is supporting 3 nodes, but additional nodes may be added. <br>
End user may target different hosts, by providing the IP addressed of these hosts along with the required credentials. <br>
It is strongly recommended, the use of public key authentication for setting up the connection between the Ansible master node and the K8s nodes. The keys may be stored under the emeralds_user folder. See Prerequisites for key creation steps.

### Emeralds Repository Configuration

 The respository for the Argo CD, along with the token needed for the repo is specified in the ${REPO-ROOT}/ansible/host_vars/master1 folder<br> 
The argocd_apps.yaml file  contains information such as the intended branch and the path under which the manifests are located at.<br>
The repo.yaml file contains the user credentials to access the repository. 

### Kuberneted Configuration
Before proceeding with the execution of the ansible playbooks, please proceed with the required condifuration of the values.yaml file under the ${REPO_ROOT}/kubernetes/hosting-services/values.yaml file. <br>

## Prerequisites
The Scripts required a Linux OS. For Windows Users, you may use the WSL feature. 
The required software can also be install in Debian based systems with the execution of the script

```bash
chmod +x ./init_project_ubuntu.sh
./init_project_ubuntu.sh
```

### SSH keys and repo token
Manual SSH key creation (if `emeralds_user` keys are missing):
1. Generate a keypair on the Ansible control host:
```bash
mkdir -p ./emeralds_user
ssh-keygen -t ed25519 -f ./emeralds_user/ssh -C "emeralds-ansible" -N ""
```
2. Copy the public key to each target host user (for example `emeralds-user`):
```bash
ssh-copy-id -i ./emeralds_user/ssh.pub emeralds-user@<host-ip>
```
3. Ensure private key permissions are restricted:
```bash
chmod 600 ./emeralds_user/ssh
```
If you use a different key filename, update `inventory.yaml` to point to it.

Repo credentials via environment variable:
1. Create a `.env` file from the template and set the username and token:
```bash
cp .env.template .env
```
2. Load it into your shell before running Ansible:
```bash
set -a
source .env
set +a
```
### Installation of Ansible tool
Python and Ansible tools can be easily deployed through the OS package management tool. <br>
For Ubuntu/Debian users, the Python is usually installed in the system. 
For the installation of ansible please execute the following commands

```bash
sudo apt update
sudo apt install -y ansible sshpass
```
### Install ansible galaxy-roles 
For installing the required external roles, you may execute the following command

```bash
cd ${REPO_ROOT}/ansible
ansible-galaxy install -r requirements.yml
```

## Commands
In order to install the needed dependencies on every host along with a microk8s cluster the `plkb-main.yml` will be used via the following command

```bash
ansible-playbook plkb-main.yml
```

## usefull link
https://www.server-world.info/en/note?os=Ubuntu_24.04&p=microk8s&f=8

### Enable Dashboard
```bash
sudo microk8s enable  dashboard
```

Retrieve Token
```bash
microk8s kubectl describe secret -n kube-system microk8s-dashboard-token | grep ^token
```

Port forward Traffic
```bash
microk8s kubectl port-forward -n kube-system service/kubernetes-dashboard 10443:443 --address 0.0.0.0
```
Access Url [https://Cluster_Ext_IP:10443/#/login]

### Enable Observability
without tempo and with additional configuration through microk8s-addon-observability-values.yaml
```bash
sudo microk8s enable  observability --kube-prometheus-stack-values=./kubernetes/observability/microk8s-addon-observability-values.yaml --without-tempo
```
TODO::Creds  user: admin. Password can be found on microk8s-addon-observability-values.yaml

Port forward prometheus
```bash
kubectl port-forward -n observability service/prometheus-operated --address 0.0.0.0 9090:9090
```

Port Forward grafana
```bash
kubectl port-forward -n observability service/kube-prom-stack-grafana --address 0.0.0.0 3000:80
```
As an alternative, create a Service of type NodePort
```bash
kubectl apply -f ./kubernetes/observability/grafana-service.yaml 
```
