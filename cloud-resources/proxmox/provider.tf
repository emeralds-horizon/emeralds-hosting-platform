terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc01"  # or latest
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://${var.proxmox_url}/api2/json"
  pm_user         =  var.proxmox_user
  pm_password     =  var.proxmox_password
  pm_tls_insecure = true  # only for self-signed certs
}