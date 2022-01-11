
locals {
  template = templatefile("floppy/Autounattend.xml.pkrtpl.hcl", {
    drive_letter_drivers = var.drive_letter.drivers,
    drive_letter_scripts = var.drive_letter.scripts,
    image_catalog_source = var.image.catalog_source,
    image_name = var.image.name,
    image_product_key = var.image.product_key,
    locale_code = var.locale.code,
    locale_name = var.locale.name,
    locale_time_zone = var.locale.time_zone,
    user_name = var.user.name,
    user_display_name = var.user.display_name,
    user_password = var.user.password,
    user_is_pw_plain_text = var.user.is_pw_plain_text,
    user_group = var.user.group,
    user_registered_org = var.user.registered_org,
    user_registered_owner = var.user.registered_owner,
    hostname = var.hostname
  })
}
source "file" "autounattend" {
  content = local.template
  target = "${var.floppy}/Autounattend.xml"
}

build {
  source "source.file.autounattend" {}
}

source "file" "transfer_autounattend_log" {}

build {
  source "source.file.transfer_autounattend_log" {
    target = "./iso_log.txt"
  }

  provisioner "shell-local" {
    inline = [
      # "while [[ ! -f /mnt/h/source/orgs/shortpoet-ansible/proxmox-template/packer/win10/floppy/Autounattend.xml ]]; do sleep 5; done;",
      "while [ ! -f /mnt/h/source/orgs/shortpoet-ansible/proxmox-template/packer/win10/${var.floppy}/Autounattend.xml ]; do sleep 5; done;",
      "mkisofs -J -l -R -V 'Label CD' -iso-level 4 -o '/mnt/h/source/orgs/shortpoet-ansible/proxmox-template/packer/win10/${var.floppy}/${var.autounattend_iso}.iso' '/mnt/h/source/orgs/shortpoet-ansible/proxmox-template/packer/win10/${var.floppy}/' 2>&1 | tee -a iso_log.txt",
      "scp /mnt/h/source/orgs/shortpoet-ansible/proxmox-template/packer/win10/${var.floppy}/${var.autounattend_iso}.iso proxmox:/var/lib/vz/template/iso/ 2>&1 | tee -a iso_log.txt",
      "rm /mnt/h/source/orgs/shortpoet-ansible/proxmox-template/packer/win10/${var.floppy}/${var.autounattend_iso}.iso"
    ]
  }
}

build {
  name = "windows10"
  description = <<EOF
This build creates windows images for windows versions :
* 10 Pro
For the following builers :
* packer
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
  post-processor "manifest" {
    output     = "${var.floppy}-manifest.json"
    strip_path = false
  }

}
