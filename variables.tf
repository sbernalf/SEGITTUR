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
  default     = "Standard_D2s_v4"
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
    "https://stgsegittur.blob.core.windows.net/scriptsens/Post-Config_Script.sh",
    "https://stgsegittur.blob.core.windows.net/scriptsens/CCN-STIC-610A22_01-Contraseña_grub.sh",
    "https://stgsegittur.blob.core.windows.net/scriptsens/CCN-STIC-610A22_02-Usuarios_root_y_sin_contraseña.sh",
    "https://stgsegittur.blob.core.windows.net/scriptsens/CCN-STIC-610A22_03-Parametros_del_kernel.sh",
    "https://stgsegittur.blob.core.windows.net/scriptsens/CCN-STIC-610A22_04-Parametros_SSH.sh",
    "https://stgsegittur.blob.core.windows.net/scriptsens/CCN-STIC-610A22_05-Manipulacion_de_registros_de_actividad.sh",
    "https://stgsegittur.blob.core.windows.net/scriptsens/CCN-STIC-610A22_06-Desinstalar_usuarios_innecesarios.sh",
    "https://stgsegittur.blob.core.windows.net/scriptsens/CCN-STIC-610A22_07-intentos_fallidos.sh",
    "https://stgsegittur.blob.core.windows.net/scriptsens/CCN-STIC-610A22_08-Limites_permisos_y_cad_contraseñas.sh",
    "https://stgsegittur.blob.core.windows.net/scriptsens/CCN-STIC-610A22_09-Parametros_gnome.sh",
    "https://stgsegittur.blob.core.windows.net/scriptsens/CCN-STIC-610A22_10-Elementos_innecesarios.sh",
    "https://stgsegittur.blob.core.windows.net/scriptsens/CCN-STIC-610A22_11-Paquetes_huerfanos.sh",
    "https://stgsegittur.blob.core.windows.net/scriptsens/CCN-STIC-610A22_Limitacion_usb.sh",
    "https://stgsegittur.blob.core.windows.net/scriptsens/Restart.sh"
  ]
}
