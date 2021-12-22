#############################################################
# Proxmox variables
#############################################################
variable "proxmox_hostname" {
  description = "Proxmox host address (e.g. https://192.168.1.1:8006)"
  type = string
}

variable "proxmox_username" {
  description = "Proxmox username (e.g. root@pam)"
  type = string
}

variable "proxmox_password" {
  description = "Proxmox password"
  type = string
}

variable "proxmox_node_name" {
  description = "Proxmox node"
  type = string
}

variable "proxmox_insecure_skip_tls_verify" {
  description = "Skip TLS verification?"
  type = bool
  default = true
}

#############################################################
# Template variables
#############################################################
variable "template_description" {
  description = "Template description"
  type = string
  default = "Ubuntu Server 18.05 template (generated by Packer)"
}

variable "vm_id" {
  description = "VM template ID"
  type = number
}

variable "vm_name" {
  description = "VM name"
  type = string
  default = "ubuntu-server-18-05-amd64"
}

variable "vm_storage_pool" {
  description = "Storage where template will be stored"
  type = string
  default = "local-lvm"
}

variable "vm_cores" {
  description = "VM amount of memory"
  type = number
  default = 2
}

variable "vm_memory" {
  description = "VM amount of memory"
  type = number
  default = 2048
}

variable "vm_sockets" {
  description = "VM amount of CPU sockets"
  type = number
  default = 1
}

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
  description = " Name of resource pool to create virtual machine in"
  type = string
  default = ""
}

#############################################################
# OS Settings
#############################################################
variable "username" {
  description = "Default username"
  type = string
  default = "deploy"
}

variable "user_password" {
  description = "Default user password"
  type = string
}

variable "time_zone" {
  description = "Time Zone"
  type = string
  default = "UTC"
}