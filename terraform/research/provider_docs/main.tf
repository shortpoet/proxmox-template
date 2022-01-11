/* Null resource that generates a cloud-config file per vm */
data "template_file" "user_data" {
  count    = var.vm_count
  template = file("${path.module}/files/user_data.cfg")
  vars = {
    pubkey   = file("~/.ssh/id_rsa.pub")
    hostname = "vm-${count.index}"
    fqdn     = "vm-${count.index}.${var.domain_name}"
  }
}
resource "local_file" "cloud_init_user_data_file" {
  count    = var.vm_count
  content  = data.template_file.user_data[count.index].rendered
  filename = "${path.module}/files/user_data_${count.index}.cfg"
}

resource "null_resource" "cloud_init_config_files" {
  count = var.vm_count
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

/* Configure cloud-init User-Data with custom config file */
resource "proxmox_vm_qemu" "cloudinit-test" {
  depends_on = [
    null_resource.cloud_init_config_files,
  ]

  name        = "tftest1.xyz.com"
  desc        = "tf description"
  target_node = "proxmox1-xx"

  clone = "ci-ubuntu-template"

  # The destination resource pool for the new VM
  pool = "pool0"

  storage = "local"
  cores   = 3
  sockets = 1
  memory  = 2560
  disk_gb = 4
  nic     = "virtio"
  bridge  = "vmbr0"

  ssh_user        = "root"
  ssh_private_key = <<EOF
-----BEGIN RSA PRIVATE KEY-----
private ssh key root
-----END RSA PRIVATE KEY-----
EOF

  os_type   = "cloud-init"
  ipconfig0 = "ip=10.0.2.99/16,gw=10.0.2.2"

  /*
    sshkeys and other User-Data parameters are specified with a custom config file.
    In this example each VM has its own config file, previously generated and uploaded to
    the snippets folder in the local storage in the Proxmox VE server.
  */
  cicustom = "user=local:snippets/user_data_vm-${count.index}.yml"
  /* Create the cloud-init drive on the "local-lvm" storage */
  cloudinit_cdrom_storage = "local-lvm"

  provisioner "remote-exec" {
    inline = [
      "ip a"
    ]
  }
}
