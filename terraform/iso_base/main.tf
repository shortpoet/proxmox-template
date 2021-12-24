locals {
  vmid = var.vm_type == "template" ? 9003 : 100
}


resource "proxmox_vm_qemu" "proxmox_vm" {

  count       = length(var.hosts)
  name        = var.hosts[count.index].hostname
  target_node = var.proxmox_host["target_node"]
  vmid        = local.vmid + count.index

  # full_clone  = true
  # clone       = "cloud-init-focal"

  # The destination resource pool for the new VM
  pool = "pool0"


  cores    = 2
  sockets  = 1
  vcpus    = 2
  memory   = 2048
  balloon  = 2048
  boot     = "c"
  bootdisk = "virtio0"

  scsihw = "virtio-scsi-pci"

  iso = "./hirsute-server-cloudimg-amd64.img"

  onboot = false
  agent  = 1
  # cpu     = "kvm64" # defaults to host
  numa    = true
  hotplug = "network,disk,cpu,memory,usb"

  # nic     = "virtio"
  # bridge  = "vmbr0"
  network {
    bridge = "vmbr0"
    model  = "virtio"
  }

  # disk_gb = 4
  # storage = var.storage_pool
  disk {
    #id = 0
    type    = "virtio"
    storage = var.storage_pool
    size    = var.rootfs_size
  }

  os_type = "cloud-init"
  # this is a mistake in docs cloud init example
  # cloudinit_cdrom_storage = "local-lvm"
  ipconfig0 = "dhcp"
  # ipconfig0 = "ip=${var.ips[count.index]}/24,gw=${cidrhost(format("%s/24", var.ips[count.index]), 1)}"
  # ipconfig0 = "ip=10.0.2.99/16,gw=10.0.2.2"

  /*
    sshkeys and other User-Data parameters are specified with a custom config file.
    In this example each VM has its own config file, previously generated and uploaded to
    the snippets folder in the local storage in the Proxmox VE server.
  */
  # cicustom = "user=local:snippets/user_data_vm-${count.index}.yml"
  /* Create the cloud-init drive on the "local-lvm" storage */

  #   ssh_user        = "root"
  #   ssh_private_key = <<EOF
  # -----BEGIN RSA PRIVATE KEY-----
  # private ssh key root
  # -----END RSA PRIVATE KEY-----
  #   EOF


  #creates ssh connection to check when the CT is ready for ansible provisioning
  # connection {
  #   host        = var.hosts[count.index].ip
  #   user        = var.user
  #   private_key = file(var.ssh_keys["priv"])
  #   agent       = false
  #   timeout     = "3m"
  # }

  provisioner "remote-exec" {
    inline = [
      "echo 'Cool, we are ready for provisioning'",
      "ip a"
    ]
  }

  # provisioner "remote-exec" {
  #   # Leave this here so we know when to start with Ansible local-exec 
  #   inline = ["echo 'Cool, we are ready for provisioning'"]
  # }

  # provisioner "local-exec" {
  #   working_dir = "../../ansible/"
  #   command     = "ansible-playbook -u ${var.user} --key-file ${var.ssh_keys["priv"]} -i ${var.ips[count.index]}, provision.yaml"
  # }

  # provisioner "local-exec" {
  #   working_dir = "../../ansible/"
  #   command     = "ansible-playbook -u ${var.user} --key-file ${var.ssh_keys["priv"]} -i ${var.ips[count.index]}, install-qemu-guest-agent.yaml"
  # }
}
