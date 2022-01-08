
source "proxmox" "win10x64_template" {
  proxmox_url              = "${var.proxmox_hostname}/api2/json"
  insecure_skip_tls_verify = "${var.proxmox_insecure_skip_tls_verify}"
  username                 = var.proxmox_username
  password                 = var.proxmox_password
  node                     = var.proxmox_node_name

  # template_name         = var.vm_name
  # template_description  = var.template_description

  template_description = "${local.template_description}"
  vm_name              = "${var.vm_name}"
  vm_id                = var.vm_id

  memory   = var.vm_memory
  sockets  = var.vm_sockets
  cores    = "${var.vm_cpu_cores}"
  os       = "win10"
  cpu_type = "host"

  communicator   = "winrm"
  winrm_insecure = true
  winrm_password = "${var.winrm_password}"
  winrm_use_ssl  = true
  winrm_username = "${var.winrm_username}"


  iso_file = var.iso_file
  # iso_url               = var.iso_url
  iso_storage_pool = "${var.iso_storage_pool}"
  unmount_iso      = true

  # http_directory        = "http"
  # boot_wait             = "3s"

  network_adapters {
    bridge = "vmbr0"
    # model    = "e1000"
    # vlan_tag = "102"
  }

  qemu_agent      = true
  scsi_controller = "virtio-scsi-pci"

  disks {
    disk_size         = "${var.disk_size}"
    format            = "${var.disk_storage_format}"
    storage_pool      = "${var.disk_storage_pool}"
    storage_pool_type = "${var.disk_storage_pool_type}"
    type              = "scsi"
  }


  # command: "qm create {{next_vmid.stdout}} --name {{template_name}} --sockets {{vm_sockets}} --cores {{vm_cores}} --memory {{vm_memory_mb}} --ide2 file={{os_iso_location}},media=cdrom --ide3 file=local:iso/{{template_name}}Provision.iso,media=cdrom --net0 model=virtio,bridge=vmbr0,firewall=1 --scsihw virtio-scsi-pci --scsi0 {{pve_storage_id}}:{{drive_size_gb}},format={{format}} --ostype {{vm_os_type}} --agent {{agent}}"

  additional_iso_files {
    device = "ide1"
    # iso_checksum     = "7226710d4abe5def4c8722bff7222f80a43462f0"
    iso_storage_pool = "${var.iso_storage_pool}"
    iso_file         = "${var.iso_storage_pool}/Autounattend.iso"
    # iso_file = "${var.iso_storage_pool}/Autounattend.iso"
    unmount = true
  }

  additional_iso_files {
    device   = "ide3"
    iso_file = "${var.iso_storage_pool}/${var.virtio_driver_iso}"
    unmount  = true
  }

}
