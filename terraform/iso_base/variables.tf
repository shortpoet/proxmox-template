variable "proxmox_host" {
  type = map(any)
  default = {
    pm_api_url  = "https://192.168.1.88:8006/api2/json"
    pm_user     = "automation@pve"
    target_node = "proxmox"
  }
}

variable "proxmox_password" {}

variable "vm_type" {
  default     = "template"
  description = "Type of vm: template, clone"
  type        = string
}

variable "hosts" {
  description = "VMs to be created: hostname, IP"
  type = list(object({
    hostname = string
    ip       = string
  }))
  default = []
}

variable "ssh_keys" {
  type = map(any)
  default = {
    pub  = "~/.ssh/id_ed25519_ansible.pub"
    priv = "~/.ssh/id_ed25519_ansible"
  }
}

variable "ssh_password" {
  type    = string
  default = null
}

variable "user" {
  default     = "notroot"
  description = "User used to SSH into the machine and provision it"
}

variable "rootfs_size" {
  default = "2G"
}

variable "storage_pool" {
  type        = string
  description = "Name of storage pool for main and cloudinit drives."
  default     = "vmstore"
}
