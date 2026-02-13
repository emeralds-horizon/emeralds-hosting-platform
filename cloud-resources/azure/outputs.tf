output "public_ips" {
  value = {
    for name in var.vm_names :
    name => azurerm_public_ip.public_ip[name].ip_address
  }
}

output "resource_group_location" {
  value = data.azurerm_resource_group.rg.location
}


