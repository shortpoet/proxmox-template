data "template_file" "user_data" {
  count    = length(var.hostnames)
  template = file("${path.module}/files/user_data.cfg")
  vars = {
    pubkey   = file("~/.ssh/id_rsa.pub")
    hostname = "vm-${count.index}"
    fqdn     = "vm-${count.index}.${var.domain_name}"
  }
}
resource "local_file" "cloud_init_user_data_file" {
  count    = length(var.hostnames)
  content  = data.template_file.user_data[count.index].rendered
  filename = "${path.module}/files/user_data_${count.index}.cfg"
}

resource "null_resource" "cloud_init_config_files" {
  count = length(var.hostnames)
  connection {
    type     = "ssh"
    user     = var.pve_user
    password = var.pve_password
    host     = var.pve_host
  }

  provisioner "file" {
    source      = local_file.cloud_init_user_data_file[count.index].filename
    destination = "/var/lib/vz/snippets/user_data_vm-${count.index}.yml"
  }
}


resource "proxmox_vm_qemu" "proxmox_vm" {
  depends_on = [
    null_resource.cloud_init_config_files,
  ]

  count       = length(var.hostnames)
  name        = var.hostnames[count.index]
  target_node = var.proxmox_host["target_node"]
  vmid        = var.vmid + count.index

  # full_clone  = true
  # clone       = "cloud-init-focal"

  # The destination resource pool for the new VM
  pool = "pool0"

  storage = "local"
  disk_gb = 4

  cores    = 2
  sockets  = 1
  vcpus    = 2
  memory   = 2048
  balloon  = 2048
  boot     = "c"
  bootdisk = "virtio0"

  scsihw = "virtio-scsi-pci"

  onboot  = false
  agent   = 1
  cpu     = "kvm64"
  numa    = true
  hotplug = "network,disk,cpu,memory"

  # nic     = "virtio"
  # bridge  = "vmbr0"
  network {
    bridge = "vmbr0"
    model  = "virtio"
  }

  disk {
    #id = 0
    type    = "virtio"
    storage = "local-lvm"
    size    = "5G"
  }

  os_type   = "cloud-init"
  ipconfig0 = "ip=${var.ips[count.index]}/24,gw=${cidrhost(format("%s/24", var.ips[count.index]), 1)}"
  # ipconfig0 = "ip=10.0.2.99/16,gw=10.0.2.2"

  /*
    sshkeys and other User-Data parameters are specified with a custom config file.
    In this example each VM has its own config file, previously generated and uploaded to
    the snippets folder in the local storage in the Proxmox VE server.
  */
  cicustom = "user=local:snippets/user_data_vm-${count.index}.yml"
  /* Create the cloud-init drive on the "local-lvm" storage */
  cloudinit_cdrom_storage = "local-lvm"

  ssh_user        = "root"
  ssh_private_key = <<EOF
-----BEGIN RSA PRIVATE KEY-----
private ssh key root
-----END RSA PRIVATE KEY-----
  EOF


  #creates ssh connection to check when the CT is ready for ansible provisioning
  connection {
    host        = var.ips[count.index]
    user        = var.user
    private_key = file(var.ssh_keys["priv"])
    agent       = false
    timeout     = "3m"
  }

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
