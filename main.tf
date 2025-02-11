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
  subscription_id = "3f3e4b19-5361-4750-8e53-d52332f72899"  # Reemplaza con tu ID de suscripción
  resource_provider_registrations = "none"
}

# Grupo de recursos
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# IP pública
resource "azurerm_public_ip" "vm_public_ip" {
  name                = "myPublicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Red Virtual
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

# Interfaz de Red
resource "azurerm_network_interface" "nic" {
  name                = "nic-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    
    # Asignar la IP pública directamente a través de su ID
    public_ip_address_id = azurerm_public_ip.vm_public_ip.id
  }
  }

# VM con Red Hat y autenticación SSH
resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  admin_username      = var.admin_username
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
    disk_size_gb         = 30
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
