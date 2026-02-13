# Description

Automation scripts to deploy cloud resources forthe EMERALDS Hosting Services Platform.

For the deployment of the cloud resources (Resource Group, Networks, Firewall rules and VMs), OpenTofu [docs](https://opentofu.org/docs/) has been used, as an open-source branch of Terraform tool.

Azure Cloud is currently supported.

In the context of EMERALDS, the scripts can deploy only the cloud VMs for the Kubernetes Cluster.
Edge and Fog devices that are deployed on different supervisor depend on the underlying technology and network access and therefore the automated creation of the resources is not quaranteed.

Note: Due to account limitations, the Group Resource has been created manually - User may comment out the relevant code in order to fully automate the resource creation.

## Execution of scripts and deployment of the resouces

1. User needs to have a valid Azure account with RBAC access to resource creation.
2. User needs to install az cli tool and login to his/hers account to Azure.
3. Navigate to cloud-resources folder:
4. Create a {any name of choice}.tfvar file and set the value for the variables defined in the variables.tf file.
5. tofu init
6. tofu plan (to verify the created resources and dry-run the resource creation)
7. tofu apply

## Access to cloud resources

In order to access the cloud resources you need their public IP address, admin user (defined in variables) and the ssh key.

The ssh keys are generated during opentofu plan and stored at ${Project_Root_Folder}/users/ssh_keys/

For the IPs you may check it after their creation using the following command:

```bash
tofu output
```

## Destroy all resources

Just execute on the same directory the following command

```bash
tofu destroy -auto-approve
```

## Store of tfstate

Upon deploying the Cloud resources, the openTofu is saving the state of the created resources on a local file named "terraform.tfstate". This file should be placed on a shared repository (not necessarily git) and shared among DevOps team. 
Consequent tofu commands such as "tofu destroy" or "tofu apply" for new resources, will have unexpected results in the provisionined resources.
