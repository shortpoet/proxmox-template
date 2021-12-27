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
  # disks {
  #   disk_size         = "5G"
  #   format            = "qcow2"
  #   storage_pool      = "vmstore"
  #   storage_pool_type = "${var.disk_storage_pool_type}"
  #   type              = "ide"
  # }

  # boot = "order=scsi0;ide2;net0"

  ssh_username          = var.ssh_username
  ssh_password          = var.proxmox_password
  ssh_timeout           = "35m"

  iso_file              = var.iso_file
  iso_url               = var.iso_url
  iso_storage_pool      = var.iso_storage_pool
  iso_checksum          = var.iso_checksum

  cloud_init              = true
  cloud_init_storage_pool = "vmstore"

  # onboot                = true

  # template_name         = var.vm_name
  template_description  = var.template_description
  unmount_iso           = true

  http_directory        = "http"
  boot_wait             = "3s"
  # boot_command          = [
  #   "<esc><wait>auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/<enter>"
  # ]
  boot_command          = [
    "<wait><enter><esc><wait5><f6><esc><wait>",
    "<bs><bs><bs><bs><bs>",
    "<bs><bs><bs><bs><bs>",
    "/casper/vmlinuz ",
    "initrd=/casper/initrd ",
    "ip=dhcp ",
    "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ",
    "--- <enter>"
  ]

  # boot_command = [
  #   # "<enter><enter><f6><esc><wait> ",
  #   # "autoinstall ds=nocloud-net;seedfrom=http://{{ .HTTPIP }}:{{ .HTTPPort }}/",
  #   "<esc><wait>auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/<enter>"
  #   # "<enter><wait>"
  # ]
  
  # boot_command = [
    # " <wait><enter><wait>",
    # "<f6><esc>",
  #   "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
  #   "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
  #   "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
  #   "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
  #   "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
  #   "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
  #   "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
  #   "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
  #   "<bs><bs><bs>",
  #   "/casper/vmlinuz ",
  #   "initrd=/casper/initrd ",
  #   "autoinstall ",
  #   "\"ds=nocloud-net;s=http://{{.HTTPIP}}:{{.HTTPPort}}/http\" ",
  #   "<enter>"  
  # ]

# boot_command = [
#     " <wait><enter><wait>",
#     "<f6><esc>",
#     "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
#     "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
#     "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
#     "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
#     "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
#     "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
#     "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
#     "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
#     "<bs><bs><bs>",
#     "/casper/vmlinuz ",
#     "initrd=/casper/initrd ",
#     "autoinstall net.ifnames=0 biosdevname=0 ip=dhcp ipv6.disable=1 ds=nocloud-net;s=http://{{.HTTPIP}}:{{.HTTPPort}}/",
#     "<wait><enter>"
#   ]

  # boot_command = [
  #   "<esc><wait>",
  #   "<esc><wait>",
  #   "<enter><wait>",
  #   "/install/vmlinuz ",
  #   "auto ",
  #   "console-setup/ask_detect=false ",
  #   "debconf/frontend=noninteractive ",
  #   " hostname=${var.vm_name}",
  #   "fb=false ",
  #   "grub-installer/bootdev=/dev/sda<wait> ",
  #   "initrd=/install/initrd.gz ",
  #   "kbd-chooser/method=us ",
  #   "keyboard-configuration/modelcode=SKIP ",
  #   " username=${var.username}",
  #   " time_zone=${var.time_zone}",
  #   "noapic ",
  #   " passwd/username=${var.username}",
  #   " passwd/user-fullname=${var.username}",
  #   " passwd/user-password=${var.proxmox_password}",
  #   " passwd/user-password-again=${var.proxmox_password}",
  #   " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg",
  #   "-- <enter>"
  # ]

}

build {
  sources = [
    "source.proxmox.template"
  ]

  provisioner "shell" {
    pause_before = "20s"
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
    ]
    inline = [
      "sleep 30",
      "sudo apt-get update",
      "sudo apt-get -y upgrade",
      "sudo apt-get -y dist-upgrade",
      "sudo apt-get -y install linux-generic linux-headers-generic linux-image-generic",
      "sudo apt-get -y install wget curl",

      # DHCP Server assigns same IP address if machine-id is preserved, new machine-id will be generated on first boot
      "sudo truncate -s 0 /etc/machine-id",
      "exit 0",
    ]
    # inline = ["sudo rm -f /etc/cloud/cloud.cfg.d/99-installer.cfg", "sudo cloud-init clean", "sudo passwd -d ubuntu"]
    # only   = ["proxmox"]

  }
}
