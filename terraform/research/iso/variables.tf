variable "proxmox_host" {
  type = map(any)
  default = {
    pm_api_url  = "https://192.168.1.88:8006/api2/json"
    pm_user     = "automation@pve"
    target_node = "proxmox"
  }
}

variable "vmid" {
  default     = 400
  description = "Starting ID for the CTs"
}


variable "hostnames" {
  description = "VMs to be created"
  type        = list(string)
  default     = ["prod-vm", "staging-vm", "dev-vm"]
}

variable "rootfs_size" {
  default = "2G"
}

variable "ips" {
  description = "IPs of the VMs, respective to the hostname order"
  type        = list(string)
  default     = []
  # default     = ["10.0.42.80", "10.0.42.81", "10.0.42.82"]
}

variable "ssh_keys" {
  type = map(any)
  default = {
    pub  = "~/.ssh/id_ed25519-pwless.pub"
    priv = "~/.ssh/id_ed25519-pwless"
  }
}

variable "ssh_password" {}

variable "user" {
  default     = "notroot"
  description = "User used to SSH into the machine and provision it"
}
