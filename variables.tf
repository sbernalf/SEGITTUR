variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
  default     = "rg-redhat-vm"
}

variable "location" {
  description = "Región de Azure"
  type        = string
  default     = "West Europe"
}

variable "vm_name" {
  description = "Nombre de la máquina virtual"
  type        = string
  default     = "redhat-jumphost"
}

variable "vm_size" {
  description = "Tamaño de la VM"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Nombre del usuario administrador"
  type        = string
  default     = "tseadmin"
}

variable "ssh_public_key" {
  description = "Clave SSH pública"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "script_urls" {
  description = "Lista de URLs de los scripts de configuración"
  type        = list(string)
  default     = [
    "https://raw.githubusercontent.com/empresa/scripts/main/script1.sh",
    "https://raw.githubusercontent.com/empresa/scripts/main/script2.sh",
    "https://raw.githubusercontent.com/empresa/scripts/main/script3.sh",
    "https://raw.githubusercontent.com/empresa/scripts/main/script4.sh",
    "https://raw.githubusercontent.com/empresa/scripts/main/script5.sh",
    "https://raw.githubusercontent.com/empresa/scripts/main/script6.sh",
    "https://raw.githubusercontent.com/empresa/scripts/main/script7.sh",
    "https://raw.githubusercontent.com/empresa/scripts/main/script8.sh",
    "https://raw.githubusercontent.com/empresa/scripts/main/script9.sh",
    "https://raw.githubusercontent.com/empresa/scripts/main/script10.sh",
    "https://raw.githubusercontent.com/empresa/scripts/main/script11.sh",
    "https://raw.githubusercontent.com/empresa/scripts/main/script12.sh"
  ]
}
