terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
  required_version = ">= 1.0"
}

provider "azurerm" {
  features {}
}

# Grupo de recursos
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_public_ip" "vm_public_ip" {
  name                = "myPublicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"tu caso
}

# Red virtual
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-standard"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

# Subred
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-vm"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Interfaz de red
resource "azurerm_network_interface" "nic" {
  name                = "nic-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"

    public_ip_address {
      id = azurerm_public_ip.vm_public_ip.id
  }
}

# Máquina Virtual con Red Hat y autenticación Entra ID
resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  admin_username = var.admin_username
  admin_password = "TSEIberia*2025"
  size                = var.vm_size
  network_interface_ids = [azurerm_network_interface.nic.id]

  # Imagen Red Hat con GUI
  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "9-lvm-gen2"  # Red Hat con GUI
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb      = 30
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key)
  }

  identity {
    type = "SystemAssigned"
  }

  boot_diagnostics {
    storage_account_uri = null
  }

  tags = {
    Environment = "Development"
  }
}

# Extensión de VM para ejecutar los scripts .sh
resource "azurerm_virtual_machine_extension" "custom_script" {
  name                 = "custom-script"
  virtual_machine_id   = azurerm_linux_virtual_machine.vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
    {
      "fileUris": ${jsonencode(var.script_urls)},
      "commandToExecute": "chmod +x *.sh && ./script1.sh && ./script2.sh && ./script3.sh && ./script4.sh && ./script5.sh && ./script6.sh && ./script7.sh && ./script8.sh && ./script9.sh && ./script10.sh && ./script11.sh && ./script12.sh"
    }
SETTINGS
}

