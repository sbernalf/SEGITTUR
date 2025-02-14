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

  # Definir tags globales para todos los recursos
  tags = {
    environment = "dev"
    project     = "PIA"
    owner       = "Sergio Bernal"
  }
}

# Red Virtual
resource "azurerm_virtual_network" "vnet" {
  name                = "VirtualNetwork"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

# Subred
resource "azurerm_subnet" "subnet" {
  name                 = "VMSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnetBastion" {
  name                 = "AzureBastionSubnet"  # Nombre correcto de la subred
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "publicip" {
  name                = "Bastion-PublicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                  = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = "Bastion"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                  = "Standard"

  # IP pública asociada al Bastion Host
  ip_configuration {
    name                 = "ip-config-Bastion"
    public_ip_address_id = azurerm_public_ip.publicip.id
    subnet_id            = azurerm_subnet.subnetBastion.id
  }
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
  }
  }

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-ssh_modified"
    priority                   = 1030
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1122"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-http"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-rdp"
    priority                   = 1020
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}


# VM con Red Hat y autenticación SSH
resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  admin_username      = var.admin_username
  admin_password = "2025*TSEIberia*2025"
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

  # Habilitar autenticación de contraseña (si no usas autenticación SSH)
  disable_password_authentication = false

  identity {
    type = "SystemAssigned"
  }

  boot_diagnostics {
    storage_account_uri = null
  }
}

# Extensión de VM para ejecutar los scripts .sh
resource "azurerm_virtual_machine_extension" "Post-Config_Script" {
  name                 = "Post-Config_Script"
  virtual_machine_id   = azurerm_linux_virtual_machine.vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"
  settings = <<SETTINGS
    {
      "fileUris": ${jsonencode(var.script_urls)},
      "commandToExecute": "chmod +x *.sh && ./Post-Config_Script.sh && ./CCN-STIC-610A22_03-Parametros_del_kernel.sh && ./CCN-STIC-610A22_04-Parametros_SSH.sh && ./CCN-STIC-610A22_05-Manipulacion_de_registros_de_actividad.sh && ./CCN-STIC-610A22_07-intentos_fallidos.sh && ./CCN-STIC-610A22_10-Elementos_innecesarios.sh && ./CCN-STIC-610A22_11-Paquetes_huerfanos.sh && ./CCN-STIC-610A22_Limitacion_usb.sh && ./Restart.sh"
  }
SETTINGS
}
