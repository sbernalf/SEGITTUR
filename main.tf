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
  allocation_method   = "Static"
  sku = "Standard"
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
    disk_size_gb         = 64
  }
  disable_password_authentication = false

  identity {
    type = "SystemAssigned"
  }

  boot_diagnostics {
    storage_account_uri = null
  }

  tags = {
    Environment = "Development"
    Created = "Sergio Bernal"
  }

  custom_data = base64encode(<<-EOT
    #cloud-config
    packages:
      - curl
      - wget
      - xrdp
      - xfce4
    runcmd:
      - curl -o /tmp/xrdp.sh https://stgsegittur.blob.core.windows.net/scriptsens/xrdp.sh
      - curl -o /tmp/CCN-STIC-610A22_03-Parametros_del_kernel.sh https://stgsegittur.blob.core.windows.net/scriptsens/CCN-STIC-610A22_03-Parametros_del_kernel.sh
      - chmod +x /tmp/xrdp.sh
      - /tmp/xrdp.sh
      - chmod +x /tmp/CCN-STIC-610A22_03-Parametros_del_kernel.sh
      - /tmp/CCN-STIC-610A22_03-Parametros_del_kernel.sh
  EOT
  )
}


