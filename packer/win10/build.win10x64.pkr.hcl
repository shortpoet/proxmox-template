source "file" "transfer_autounattend" {
}

build {
  source "source.file.transfer_autounattend" {
    target = "./iso_log.txt"
  }

  provisioner "shell-local" {
    inline = [
      "mkisofs -J -l -R -V 'Label CD' -iso-level 4 -o '/mnt/h/source/orgs/shortpoet-ansible/proxmox-template/packer/win10/${var.floppy}/${var.autounattend_iso}.iso' '/mnt/h/source/orgs/shortpoet-ansible/proxmox-template/packer/win10/${var.floppy}/' 2>&1 | tee -a iso_log.txt",
      "scp /mnt/h/source/orgs/shortpoet-ansible/proxmox-template/packer/win10/${var.floppy}/${var.autounattend_iso}.iso proxmox:/var/lib/vz/template/iso/ 2>&1 | tee -a iso_log.txt",
      "rm /mnt/h/source/orgs/shortpoet-ansible/proxmox-template/packer/win10/${var.floppy}/${var.autounattend_iso}.iso"
    ]
  }
}

build {
  name = "ubuntu"
  description = <<EOF
This build creates ubuntu images for ubuntu versions :
* 18.04
* 20.04
* 20.10
* 21.04
* 21.10
For the following builers :
* vsphere-iso
EOF

  sources = [
    "source.proxmox.win10x64_template"
  ]

  # provisioner "windows-shell" {
  #   scripts = ["scripts/Disable-WinUpdate.bat"]
  # }

  provisioner "powershell" {
    scripts = ["scripts/Disable-Hibernate.ps1"]
  }

  # [kalenarndt/packer-vsphere-cloud-init - Public](https://github.com/kalenarndt/packer-vsphere-cloud-init/blob/master/templates/ubuntu/20/linux-ubuntu-server.pkr.hcl)
  # post-processor "manifest" {
  #   output     = "${path.cwd}/logs/${local.buildtime}-${var.vm_guest_os_family}-${var.vm_guest_os_vendor}-${var.vm_guest_os_member}.json"
  #   strip_path = false
  # }

}
