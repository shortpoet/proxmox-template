
#############################################################
# Proxmox variables
#############################################################

variable "proxmox_hostname" {
  description = "Proxmox host address (e.g. https://192.168.1.1:8006)"
  type = string
  default = "https://192.168.1.88:8006"
}

variable "proxmox_username" {
  description = "Proxmox username (e.g. root@pam)"
  type = string
  default = "automation@pve"
}

variable "proxmox_password" {
  description = "Proxmox password"
  type = string
}

variable "proxmox_node_name" {
  description = "Proxmox node"
  type = string
  default = "proxmox"
}

variable "proxmox_insecure_skip_tls_verify" {
  description = "Skip TLS verification?"
  type = bool
  default = true
}

#############################################################
# Template variables
#############################################################

variable "iso_url" {
  description = "ISO image download link"
  type = string
  default = ""
}

variable "iso_storage_pool" {
  description = "Proxmox storage pool onto which to upload the ISO file."
  type = string
  default = ""
}

variable "iso_checksum" {
  default = ""
  type = string
  description = " Checksum of the ISO file"
}

variable "iso_file" {
  description = "Location of ISO file on the server. E.g. local:iso/<filename>.iso"
  type = string
  default = ""
}

variable "pool" {
  description = "Name of resource pool to create virtual machine in"
  type = string
  default = "templates"
}

# variable "template_description" {
#   description = "Template description"
#   type = string
# }

variable "vm_id" {
  description = "VM template ID"
  type = number
}

variable "vm_name" {
  description = "VM name"
  type = string
}

variable "vm_cpu_cores" {
  description = "VM amount of memory"
  type = number
  default = 2
}

variable "vm_memory" {
  description = "VM amount of memory"
  type = number
  default = 8192
}

variable "vm_sockets" {
  description = "VM amount of CPU sockets"
  type = number
  default = 1
}
variable "disk_size" {
  type    = string
  default = "30G"
}

variable "disk_storage_format" {
  type    = string
  default = "raw"
  description = "The storage format used by the disk"
}

variable "disk_storage_pool" {
  description = "Storage where template will be stored"
  type = string
  default = "vmstore"
}

variable "disk_storage_pool_type" {
  type    = string
  default = "lvm-thin"
  description = "Storage pool type"
}

#############################################################
# OS Settings
#############################################################

variable "virtio_driver_iso" {
  type = string
}

variable "winrm_password" {
  type    = string
  default = ""
}

variable "winrm_username" {
  type    = string
  default = ""
}
