locals {
  # https://github.com/hashicorp/packer/issues/10168
  # and then there's windows firewall
  # uri = "http://http://192.168.1.136:{{ .HTTPPort }}/" # -> this serves to localhost on wsl but not to the IP
  # uri = "http://{{ .HTTPIP }}:{{ .HTTPPort }}/" # -> this serves to ipconfig first net but prob doesn't pass firewall
  # uri = "http://${var.WIN_IP_LOCAL}:{{ .HTTPPort }}/" # -> this fails with string error in WSL but ok in win
  # boot0 = "<wait><enter><esc><wait5><f6><esc><wait> <bs><bs><bs><bs><bs> <bs><bs><bs><bs><bs> /casper/vmlinuz "
  # boot1 = "initrd=/casper/initrd ip=dhcp autoinstall ds=nocloud-net;s=${local.uri} --- <enter>"
  boot_command = [
    # "${local.boot0}${local.boot1}"

    "<wait><enter><esc><wait5><f6><esc><wait>",
    "<bs><bs><bs><bs><bs>",
    "<bs><bs><bs><bs><bs>",
    "/casper/vmlinuz ",
    "initrd=/casper/initrd ",
    "ip=dhcp ",
    # "autoinstall ds=nocloud-net;s=${local.uri}",
    # "autoinstall ds=nocloud-net;s=http://${var.WIN_IP_LOCAL}:{{ .HTTPPort }}/ ",
    "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ",
    "--- <enter>"

    # "<wait><enter><esc><wait5><f6><esc><wait> <bs><bs><bs><bs><bs> <bs><bs><bs><bs><bs> /casper/vmlinuz initrd=/casper/initrd ip=dhcp autoinstall ds=nocloud-net;s=${local.uri} --- <enter>"
    
  ]
}
source "proxmox" "template" {
  proxmox_url               = "${var.proxmox_hostname}/api2/json"
  insecure_skip_tls_verify 	= var.proxmox_insecure_skip_tls_verify
  username                  = var.proxmox_username
  password                  = var.proxmox_password
  node                      = var.proxmox_node_name

  vm_name   = var.vm_name
  vm_id     = var.vm_id

  memory    = var.vm_memory
  sockets   = var.vm_sockets
  cores     = var.vm_cores
  os        = "l26"
  cpu_type  = "host"

  network_adapters {
    model   = "virtio"
    bridge  = "vmbr0"
  }

  qemu_agent            = true
  scsi_controller       = "virtio-scsi-pci"

  disks {
    disk_size         = "8G"
    format            = "${var.disk_storage_format}"
    storage_pool      = "${var.disk_storage_pool}"
    storage_pool_type = "${var.disk_storage_pool_type}"
    type              = "scsi"
  }

  ssh_username          = var.ssh_username # notroot
  ssh_password          = var.proxmox_password
  ssh_timeout           = "35m"

  iso_file              = var.iso_file
  iso_url               = var.iso_url
  iso_storage_pool      = var.iso_storage_pool
  iso_checksum          = var.iso_checksum

  cloud_init              = true
  cloud_init_storage_pool = "vmstore"

  # template_name         = var.vm_name
  template_description  = var.template_description
  unmount_iso           = true
  
  # https://github.com/hashicorp/packer/issues/10168
  # would have to set some kind of env var but string interpolation is borked on WSL (see above)
  http_interface        = "Ethernet 2"
  http_directory        = "http"
  boot_wait             = "3s"
  boot_command          = "${local.boot_command}"
}

build {

  sources = [
    "source.proxmox.template"
  ]

  provisioner "shell" {
    inline = [
      "echo 'Waiting for cloud-init...'",
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do sleep 1; done"
    ]
  }

  # provisioner "ansible" {
  #   playbook_file = "/mnt/h/source/orgs/shortpoet-ansible/role-dotfiles/install.yml"
  # }

  # provisioner "shell" {
  #   pause_before = "20s"
  #   environment_vars = [
  #     "DEBIAN_FRONTEND=noninteractive",
  #   ]
  #   inline = [
  #     "sleep 30",
  #     "sudo apt update -y",
  #     "sudo apt -y upgrade",
  #     "sudo apt -y dist-upgrade",
  #     # "sudo apt -y install linux-generic linux-headers-generic linux-image-generic",
  #     # "sudo apt -y install wget curl",

  #     # DHCP Server assigns same IP address if machine-id is preserved, new machine-id will be generated on first boot
  #     "sudo truncate -s 0 /etc/machine-id",
  #     "exit 0",
  #   ]
  #   # inline = ["sudo rm -f /etc/cloud/cloud.cfg.d/99-installer.cfg", "sudo cloud-init clean", "sudo passwd -d ubuntu"]
  #   # only   = ["proxmox"]
  # }

  post-processor "manifest" {
    output     = "${path.root}/packer-manifest.json"
    strip_path = true
  }

}
