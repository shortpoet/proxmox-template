
iso_storage_pool  = "local:iso"
iso_file          = "local:iso/Win10_21H2_English_x64.iso"
pool              = "templates"

vm_id             = "8000"
vm_name           = "packer-win10"
floppy            = "floppy"
autounattend_iso  = "Autounattend"
# vm_id             = "8001"
# vm_name           = "packer-win10-1"
# floppy            = "floppy_1"
# autounattend_iso  = "Autounattend_1"

virtio_driver_iso = "virtio-win-0.1.208.iso"
winrm_username    = "vagrant"
winrm_password    = "vagrant"