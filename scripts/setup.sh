#!/bin/bash

template=2
case "$template" in
   "1")
    IMG_NAME="bionic-server-cloudimg-amd64.img";
    TEMPL_NAME="ubuntu1804-cloud-img";
    VM_ID="9000";
   ;;
   "2")
    IMG_NAME="focal-server-cloudimg-amd64.img";
    TEMPL_NAME="ubuntu2004-cloud-img";
    VM_ID="9001";
   ;;
   "3")
    IMG_NAME="focal-server-cloudimg-amd64-disk-kvm.img";
    TEMPL_NAME="ubuntu2004-cloud-img-kvm";
    VM_ID="9002";
   ;;
   "4")
    IMG_NAME="focal-server-cloudimg-amd64.qcow2";
    TEMPL_NAME="ubuntu2004-cloud-img-qcow";
    VM_ID="9003";
   ;;
esac

MEM="4096"
DISK_SIZE="32G"
STORAGE_POOL="vmstore"
# STORAGE_POOL="local-lvm"
# STORAGE_POOL="local"
NET_BRIDGE="vmbr0"
# Create the instance
  # https://pve.proxmox.com/wiki/Manual:_qm.conf
    # ostype: <l24 | l26 | other | solaris | w2k | w2k3 | w2k8 | win10 | win11 | win7 | win8 | wvista | wxp>
    # NUMA needs to be enabled for memory hotplug

qm create $VM_ID \
  --name $TEMPL_NAME \
  --memory $MEM \
  --net0 virtio,bridge=$NET_BRIDGE \
  --cores 1 \
  --vcpu 1 \
  --ostype l26 \
  --sockets 1 \
  --numa 1

# Import the OpenStack disk image to Proxmox storage

# qm importdisk $VM_ID $IMG_NAME $STORAGE_POOL
case "$template" in
   "1")
    qm importdisk $VM_ID $IMG_NAME $STORAGE_POOL --format qcow2
   ;;
   "2")
    qm importdisk $VM_ID $IMG_NAME $STORAGE_POOL --format qcow2
   ;;
   "3")
    qm importdisk $VM_ID $IMG_NAME $STORAGE_POOL
   ;;
   "4")
    qm importdisk $VM_ID $IMG_NAME $STORAGE_POOL --format qcow2
   ;;
esac

# Attach the disk to the virtual machine
qm set $VM_ID \
  --scsihw virtio-scsi-pci \
  --scsi0 $STORAGE_POOL:vm-$VM_ID-disk-0
  # --virtio0 $STORAGE_POOL:vm-$VM_ID-disk-0
  # --scsi0 $STORAGE_POOL:$VM_ID/vm-$VM_ID-disk-0.raw

# Allow hotplugging of network, USB and disks
qm set $VM_ID --hotplug network,disk,cpu,memory,usb
# qm set 9000 -hotplug disk,network,usb

# Set default ip to dhcp
qm set $VM_ID --ipconfig0 ip=dhcp
# or static
# qm set 999 --ipconfig0 ip=10.98.1.96/24,gw=10.98.1.1

# Enable the Qemu agent
qm set $VM_ID --agent enabled=1,fstrim_cloned_disks=1
# Add a single vCPU (for now)
qm set $VM_ID -vcpus 1

# Add a video output
qm set $VM_ID -vga qxl

# Create Cloud-Init Disk and configure boot.
# Set a second hard drive, using the inbuilt cloudinit drive;
qm set $VM_ID --ide2 $STORAGE_POOL:cloudinit

# Set the bootdisk to the imported Openstack disk
qm set $VM_ID \
  --boot c \
  --bootdisk scsi0

# Add a serial output
qm set $VM_ID \
  --serial0 socket \
  --vga serial0

# Clone VM
# First, clone the VM (here we are cloning the template with ID 9000 to a new VM with ID 999):
case "$template" in
   "1")
    VM_CLONE_ID="996"
    CLONE_NAME="1804clone-cloud-init"
   ;;
   "2")
    VM_CLONE_ID="997"
    CLONE_NAME="2004clone-cloud-init"
   ;;
   "3")
    VM_CLONE_ID="998"
    CLONE_NAME="2004clone-cloud-init-kvm-qcow"
   ;;
   "4")
    VM_CLONE_ID="999"
    CLONE_NAME="2004clone-cloud-init-qcow"
   ;;
esac

qm clone $VM_ID $VM_CLONE_ID --name $CLONE_NAME
# set clone info
  # Next, set the SSH keys and IP address:
qm set $VM_CLONE_ID  --sshkey ~/.ssh/id_ed25519_proxmox.pub
# qm set $VM_ID  --ipconfig0 ip=dhcp
qm set $VM_CLONE_ID  --ipconfig0 ip=192.168.1.99/24,gw=192.168.1.1

# Resize the primary boot disk (otherwise it will be around 2G by default)
# This step adds another 8G of disk space, but change this as you need to
qm resize $VM_ID scsi0 $DISK_SIZE
qm resize $VM_CLONE_ID scsi0 $DISK_SIZE
# qm resize $VM_ID scsi0 $DISK_SIZE
# qm resize 9000 virtio0 +8G

# Convert the VM to the template
qm template $VM_ID

# It’s now ready to start up!
qm start $VM_CLONE_ID

# ssh into vm

ssh ubuntu@192.168.1.99

# cleanup
sudo qm stop 999 && sudo qm destroy 999
rm focal-server-cloudimg-amd64.img

cat >> ~/.ssh/config <<EOT

Host ubuntu1804
    AddKeysToAgent yes
    Hostname 192.168.1.99
    User ubuntu
    IdentityFile ~/.ssh/id_ed25519_proxmox
    IdentitiesOnly yes
EOT
