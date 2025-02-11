variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
  default     = "RG_SEGITTUR_2"
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
    "https://raw.github.com/sbernalf/SEGITTUR/blob/main/CCN-STIC-610A22-Script/CCN-STIC-610A22_03-Parametros_del_kernel.sh",
    "https://raw.github.com/sbernalf/SEGITTUR/blob/main/CCN-STIC-610A22-Script/CCN-STIC-610A22_04-Parametros_SSH.sh",
    "https://raw.github.com/sbernalf/SEGITTUR/blob/main/CCN-STIC-610A22-Script/CCN-STIC-610A22_05-Manipulacion_de_registros_de_actividad.sh",
    "https://raw.github.com/sbernalf/SEGITTUR/blob/main/CCN-STIC-610A22-Script/CCN-STIC-610A22_06-Desinstalar_usuarios_innecesarios.sh",
    "https://raw.github.com/sbernalf/SEGITTUR/blob/main/CCN-STIC-610A22-Script/CCN-STIC-610A22_07-intentos_fallidos.sh",
    "https://raw.github.com/sbernalf/SEGITTUR/blob/main/CCN-STIC-610A22-Script/CCN-STIC-610A22_09-Parametros_gnome.sh",
    "https://raw.github.com/sbernalf/SEGITTUR/blob/main/CCN-STIC-610A22-Script/CCN-STIC-610A22_10-Elementos_innecesarios.sh",
    "https://raw.github.com/sbernalf/SEGITTUR/blob/main/CCN-STIC-610A22-Script/CCN-STIC-610A22_11-Paquetes_huerfanos.sh",
    "https://raw.github.com/sbernalf/SEGITTUR/blob/main/CCN-STIC-610A22-Script/CCN-STIC-610A22_Limitacion_usb.sh",
  ]
}
