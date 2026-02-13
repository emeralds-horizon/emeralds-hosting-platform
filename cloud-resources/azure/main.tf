terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    tls = { # Add TLS provider
      source  = "hashicorp/tls"
      version = "~> 4.1" # Use an appropriate version
    }
  }
}

provider "azurerm" {
    features {}  # Required block, even if empty
    #resource_provider_registrations = "none"

    # Optional settings:
    # subscription_id = "your-subscription-id"
    # client_id       = "your-client-id"
    # client_secret   = "your-client-secret"
    # tenant_id       = "your-tenant-id"
    # environment     = "public"  # or "china", "german", "usgovernment"
    skip_provider_registration = true # This is useful if you are using an Azure account with restrictions. In this case you may need to registered the provider manually.
    # partner_id      = "your-partner-id"
    # use_msi         = false
    # auxiliary_tenant_ids = []
    # disable_terraform_partner_id = false
    # metadata_host   = "your-metadata-host"
    # storage_use_azuread = false
}

# Uncomment the following block if you want to create a new resource group
/*
resource "azurerm_resource_group" "rg" {
  name     = "emeralds-rg"
  location = "North Europe"
}
*/


# Generate SSH key using the TLS provider
resource "tls_private_key" "vm_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "ssh_private_key_file" {
  content  = tls_private_key.vm_ssh_key.private_key_pem
  filename = "${path.module}/../users/ssh-keys/id_rsa"
  file_permission = "0600" # Restrictive permissions for private key
}

resource "local_file" "ssh_public_key_file" {
  content  = tls_private_key.vm_ssh_key.public_key_openssh
  filename = "${path.module}/../../users/ssh-keys/id_rsa.pub"
  file_permission = "0644"
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "azurerm_virtual_network" "vnet" {
  name                = "knt-cloud-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "knt-cloud-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "knt-cloud-nsg"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowAnyCustom8080Inbound"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "8080-8081"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "public_ip" {
  for_each            = toset(var.vm_names)
  name                = "knt-cloud-${each.key}-public-ip"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Basic"
}

resource "azurerm_network_interface" "nic" {
  for_each            = toset(var.vm_names)
  name                = "knt-cloud-nic-${each.key}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip[each.key].id
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  for_each                  = toset(var.vm_names)
  network_interface_id      = azurerm_network_interface.nic[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each            = toset(var.vm_names)
  name                = "knt-cloud-${each.key}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  size                = "Standard_B1s"  # 1 vCPU, 1 GiB RAM (lowest possible)
  admin_username      =  var.username
  computer_name       = "hostname"
  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id,
  ]
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.username
    public_key = tls_private_key.vm_ssh_key.public_key_openssh 
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

   source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  # If you save keys to files and need the VM to depend on those files being written first
  # (though not strictly necessary for the public_key attribute itself)
  depends_on = [
    local_file.ssh_public_key_file,
    local_file.ssh_private_key_file
  ]
}

