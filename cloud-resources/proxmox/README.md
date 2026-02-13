# Create Micro VMs on Proxmox hypervisor

## Prerequisites
Set the cloud-init password and SSH public keys via variables (do not hardcode secrets in `main.tf`).

Option A: environment variables
```bash
export TF_VAR_ci_password="your-strong-password"
export TF_VAR_ssh_keys="ssh-ed25519 AAAA... user@host"
```

Option B: `*.tfvars` file (recommended for local use)
```hcl
ci_password = "your-strong-password"
ssh_keys    = "ssh-ed25519 AAAA... user@host"
```

Note: avoid committing real secrets to git. Use a local `terraform.tfvars` (or `*.tfvars`) that is gitignored.

## Cloud-init setup

[getting started](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/guides/cloud-init%2520getting%2520starteds)
[proxmox_vm_qemu](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu)
