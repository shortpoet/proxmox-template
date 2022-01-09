# [dbond007/Packer - Public](https://github.com/dbond007/Packer/blob/master/windows_base/variables.common.pkr.hcl)
# locals {
#   // fileset lists all files in the http directory as a set, we convert that
#   // set to a list of strings and we then take the directory of the first
#   // value. This validates that the http directory exists even before starting
#   // any builder/provisioner.
#   floppy_drivers_directory = dirname(convert(fileset(".", "etc/floppy/drivers/amd64/*"), list(string))[0])
#   floppy_scripts_directory = dirname(convert(fileset(".", "etc/floppy/scripts/*"), list(string))[0])
#   iso_url_win_2k19                = "[NFS01] ISOs/en_windows_server_2019_updated_feb_2020_x64_dvd_de383770.iso"
#   iso_checksum_url_win_2k19       = ""
#   iso_url_vmware_tools            = "[NFS01] ISOs/VMware-tools-windows-11.1.1-16303738.iso"
#   iso_checksum_url_vmware_tools   = ""
#   iso_url_vmware_drivers          = "[NFS01] ISOs/VMware_pvscsi.iso"
#   iso_checksum_url_vmware_drivers = ""
#   win_2k19_boot_command           = ["<enter>","<enter>"]
#   clean_time                      = formatdate("YYMMDDhhmmss",timestamp())
# }
locals {
  template_description = "Windows 10 64-bit Enterprise template built with Packer - ${formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())}"
}

#############################################################
# Proxmox variables
#############################################################

variable "proxmox_hostname" {
  description = "Proxmox host address (e.g. https://192.168.1.1:8006)"
  type        = string
  default     = "https://192.168.1.88:8006"
}

variable "proxmox_username" {
  description = "Proxmox username (e.g. root@pam)"
  type        = string
  default     = "automation@pve"
}

variable "proxmox_password" {
  description = "Proxmox password"
  type        = string
}

variable "proxmox_node_name" {
  description = "Proxmox node"
  type        = string
  default     = "proxmox"
}

variable "proxmox_insecure_skip_tls_verify" {
  description = "Skip TLS verification?"
  type        = bool
  default     = true
}

#############################################################
# Template variables
#############################################################

variable "floppy" {
  description = "Floppy for ISO for autounattend and scripts"
  type        = string
  default     = "floppy"
}
variable "autounattend_iso" {
  description = "ISO for autounattend and scripts"
  type        = string
  default     = "Autounattend"
}
variable "iso_url" {
  description = "ISO image download link"
  type        = string
  default     = ""
}

variable "iso_storage_pool" {
  description = "Proxmox storage pool onto which to upload the ISO file."
  type        = string
  default     = ""
}

variable "iso_checksum" {
  default     = ""
  type        = string
  description = " Checksum of the ISO file"
}

variable "iso_file" {
  description = "Location of ISO file on the server. E.g. local:iso/<filename>.iso"
  type        = string
  default     = ""
}

variable "pool" {
  description = "Name of resource pool to create virtual machine in"
  type        = string
  default     = "templates"
}

# variable "template_description" {
#   description = "Template description"
#   type = string
# }

variable "vm_id" {
  description = "VM template ID"
  type        = number
}

variable "vm_name" {
  description = "VM name"
  type        = string
}

variable "vm_cpu_cores" {
  description = "VM amount of memory"
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "VM amount of memory"
  type        = number
  default     = 8192
}

variable "vm_sockets" {
  description = "VM amount of CPU sockets"
  type        = number
  default     = 1
}
variable "disk_size" {
  type    = string
  default = "60G"
}

variable "disk_storage_format" {
  type        = string
  default     = "qcow2"
  description = "The storage format used by the disk"
}

variable "disk_storage_pool" {
  description = "Storage where template will be stored"
  type        = string
  default     = "vmstore"
}

variable "disk_storage_pool_type" {
  type        = string
  default     = "lvm-thin"
  description = "Storage pool type"
}

#############################################################
# OS Settings
#############################################################

variable "virtio_driver_iso" {
  type = string
}

variable "winrm_password" {
  type = string
  sensitive = true
  description = "The password for the username of the account that should be used to connect to the windows instance via SSH"
}

variable "winrm_username" {
  type = string
  description = "The username of the account that should be used to connect to the windows instance via SSH"
}
