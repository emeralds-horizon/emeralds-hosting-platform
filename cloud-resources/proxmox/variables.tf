variable "proxmox_url" {
  type        = string
  description = "The Url or IP address of the Proxmox server."
}

variable "proxmox_user" {
  type = string
  description = "The username for the Proxmox server."
  default = "root@pam"  # Default Proxmox user
}

variable "proxmox_password" {
  type        = string
  description = "The password for the Proxmox server."
  sensitive   = true  # Mark as sensitive to avoid logging
}


variable "vm_id" {
  type        = number
  description = "The ID of the VM to create."
  default     = 100  
}

variable "ci_password" {
  type        = string
  description = "Cloud-init password for the VM."
  sensitive   = true
}

variable "ssh_keys" {
  type        = string
  description = "Authorized SSH public keys to inject via cloud-init."
}
