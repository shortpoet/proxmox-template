
# The "legacy_isotime" function has been provided for backwards compatability, but we recommend switching to the timestamp and formatdate functions.

locals {
  template_description = "Windows 10 64-bit Enterprise template built with Packer - ${legacy_isotime("2006-01-02 03:04:05")}"
}

source "proxmox" "template" {
  proxmox_url               = "${var.proxmox_hostname}/api2/json"
  insecure_skip_tls_verify = "${var.proxmox_insecure_skip_tls_verify}"
  username                  = var.proxmox_username
  password                  = var.proxmox_password
  node                      = var.proxmox_node_name

  # template_name         = var.vm_name
  # template_description  = var.template_description

  template_description = "${local.template_description}"
  vm_name              = "${var.vm_name}"
  vm_id     = var.vm_id

  memory    = var.vm_memory
  sockets   = var.vm_sockets
  cores        = "${var.vm_cpu_cores}"
  os        = "win10"
  cpu_type  = "host"


  winrm_insecure       = true
  winrm_password       = "${var.winrm_password}"
  winrm_use_ssl        = true
  winrm_username       = "${var.winrm_username}"

  communicator = "winrm"

  iso_file              = var.iso_file
  # iso_url               = var.iso_url
  iso_storage_pool      = "${var.iso_storage_pool}"
  unmount_iso           = true

  # http_directory        = "http"
  # boot_wait             = "3s"

  additional_iso_files {
    device           = "sata3"
    # iso_checksum     = "7226710d4abe5def4c8722bff7222f80a43462f0"
    iso_storage_pool      = "${var.iso_storage_pool}"
    iso_file = "${var.iso_storage_pool}/Autounattend.iso"
    # iso_file = "${var.iso_storage_pool}/Autounattend.iso"
    unmount          = true
  }

  additional_iso_files {
    device  = "sata4"
    iso_file = "${var.iso_storage_pool}/${var.virtio_driver_iso}"
    unmount = true
  }

  disks {
    disk_size         = "${var.disk_size}"
    format            = "qcow2"
    storage_pool      = "local"
    storage_pool_type = "directory"
    type              = "scsi"
  }

  network_adapters {
    bridge   = "vmbr0"
    # model    = "e1000"
    # vlan_tag = "102"
  }
}

build {
  sources = [
    "source.proxmox.template"
  ]

  provisioner "windows-shell" {
    scripts = ["scripts/Disable-WinUpdate.bat"]
  }

  provisioner "powershell" {
    scripts = ["scripts/Disable-Hibernate.ps1"]
  }

}
