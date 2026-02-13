resource "proxmox_vm_qemu" "cloudinit-example" {
  vmid        = var.vm_id
  name        = "test-terraform0"
  target_node = "rack"
  #agent       = 1
  cpu {
    cores   = 2
  }
  memory      = 4096
  boot        = "order=scsi0" # has to be the same as the OS disk of the template
  clone       = "ubuntu2404server-cloudinit" # The name of the template
  # vm_state    = "running"

  # Cloud-Init configuration
  #cicustom   = "vendor=local:snippets/qemu-guest-agent.yml" # /var/lib/vz/snippets/qemu-guest-agent.yml
  #ciupgrade  = true
  nameserver = "1.1.1.1 8.8.8.8"
  ipconfig0  = "ip=10.10.20.${var.vm_id}/24,gw=10.10.20.1"
  ciuser     = "root"
  cipassword = var.ci_password
  sshkeys    = var.ssh_keys

  # Most cloud-init images require a serial device for their display
  # serial {
  #   id = 0
  # }

  disk {
    type = "disk"
    storage = "virtualmachines" # The storage where the disk will be created
    size = "20G"
    slot = "scsi0"
  }

  network {
    id     = 0
    bridge = "vmbr0"
    model  = "virtio"
  }
}

# terraform {
#   required_providers {
#     proxmox = {
#       source = "Telmate/proxmox"
#       version = ">=3.0.1rc4"
#     }
#   }
# }
