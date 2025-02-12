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
    "https://stgsegittur.blob.core.windows.net/scriptsens/CCN-STIC-610A22_03-Parametros_del_kernel.sh",
    "https://github.com/sbernalf/SEGITTUR/blob/main/CCN-STIC-610A22-Script/CCN-STIC-610A22_05-Manipulacion_de_registros_de_actividad.sh",
  ]
}
