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
  description = <<-EOT
    Proxmox Password
    export PKR_VAR_proxmox_password=$(pass Homelab/proxmox/users/automation@pve)
    or
    $env:PKR_VAR_proxmox_password=$(Get-Secret -Name ProxmoxAutomation -AsPlainText)
  EOT
  type = string
}
# variable "PROXMOX_TOKEN" {
#   type = string
#   sensitive = true
#   default = env("PROXMOX_TOKEN")
# }

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
variable "WIN_IP_LOCAL" {
  description = <<-EOT
    $env:PKR_VAR_WIN_IP_LOCAL=$((Get-NetIPConfiguration | Select-Object IPv4Address -First 1).IPv4Address.IPAddress)
    or
    export PKR_VAR_WIN_IP_LOCAL=$(pwsh.exe -c '$ip=$(Get-NetIPConfiguration | Select-Object IPv4Address -First 1);$ip.IPv4Address.IPAddress')
  EOT
  type = string
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
  description = "Name of resource pool to create virtual machine in"
  type = string
  default = "templates"
}

variable "template_description" {
  description = "Template description"
  type = string
}

variable "vm_id" {
  description = "VM template ID"
  type = number
}

variable "vm_name" {
  description = "VM name"
  type = string
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
variable "ssh_username" {
  description = "Default ssh username"
  type = string
  default = "notroot"
}

# variable "user_password" {
#   description = "Default user password"
#   type = string
# }

variable "time_zone" {
  description = "Time Zone"
  type = string
  default = "UTC"
}