# proxmox-template

## dependencies

- qemu-guest-agent
- proxmoxer
- ansible
- python3
- pip3
- jmespath
- jq

## resources

- [engonzal/ansible_role_proxmox Public](https://github.com/engonzal/ansible_role_proxmox)
- [community.general.proxmox – Proxmox inventory source](https://docs.ansible.com/ansible/latest/collections/community/general/proxmox_inventory.html#examples)
- [ansible.builtin.pip – Manages Python library dependencies](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/pip_module.html)
- [community.general.proxmox_template – management of OS templates in Proxmox VE cluster](https://docs.ansible.com/ansible/latest/collections/community/general/proxmox_template_module.html#ansible-collections-community-general-proxmox-template-module)
- [community.general.proxmox_tasks_info – Retrieve information about one or more Proxmox VE tasks](https://docs.ansible.com/ansible/latest/collections/community/general/proxmox_tasks_info_module.html#ansible-collections-community-general-proxmox-tasks-info-module)
- https://docs.ansible.com/ansible/latest/collections/community/general/proxmox_kvm_module.html#ansible-collections-community-general-proxmox-kvm-module
- [kalenarndt/packer-vsphere-cloud-init - Public](https://github.com/kalenarndt/packer-vsphere-cloud-init/blob/master/templates/ubuntu/20/data/user-data.pkrtpl.hcl)

## get images

- linux
  - [openstack - Get images](https://docs.openstack.org/image-guide/obtain-images.html)
- windows

  - [Windows Appendix A: KMS Client Setup Keys](<https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/jj612867(v=ws.11)>)
  - get own product key

  ```cmd
  wmic path SoftwareLicensingService get OA3xOriginalProductKey
  ```

  - [realoriginal/windows10activation](https://gist.github.com/realoriginal/a1b35be405f86b6c7ba613a6fa189db6)
  - [Key Management Services (KMS) client activation and product keys](https://docs.microsoft.com/en-us/windows-server/get-started/kms-client-activation-keys)
  -

### Push Images

```bash
# ubuntu
ssh proxmox 'wget "http://cdimage.debian.org/cdimage/openstack/current-10/debian-10-openstack-amd64.qcow2" -P /var/lib/vz/template/iso/'
ssh proxmox 'wget "https://releases.ubuntu.com/20.04/ubuntu-20.04.3-live-server-amd64.iso" -P /var/lib/vz/template/iso/'
ssh proxmox 'wget "https://cdimage.debian.org/cdimage/release/current/amd64/iso-cd/debian-11.2.0-amd64-netinst.iso" -P /var/lib/vz/template/iso/'
ssh proxmox 'wget "http://cdimage.ubuntu.com/releases/20.04/release/ubuntu-20.04.3-live-server-arm64.iso" -P /var/lib/vz/template/iso/'
# windows
ssh proxmox 'wget "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.208-1/virtio-win-0.1.208.iso" -P /var/lib/vz/template/iso/'
scp "C:\Users\shortpoet\Documents\disk-images\win10\Win10_21H2_English_x64.iso" proxmox:/var/lib/vz/template/iso/Win10_21H2_English_x64.iso
# xml -> iso
cd /mnt/h/source/orgs/shortpoet-ansible/proxmox-template/packer/win10
mkisofs -J -l -R -V "Label CD" -iso-level 4 -o Autounattend.iso "/mnt/h/source/orgs/shortpoet-ansible/proxmox-template/packer/win10/floppy/Autounattend.xml"
scp Autounattend.iso proxmox:/var/lib/vz/template/iso/
rm Autounattend.iso
# or
scp "C:/Users/shortpoet/Downloads/ubuntu-20.04.3-live-server-arm64.iso" proxmox:/var/lib/vz/template/iso/
scp .\hirsute-server-cloudimg-amd64.img proxmox:/var/lib/vz/template/iso/
```

### Ubuntu

- get most recent release url

```bash
release_codename='Focal Fossa'
sstream-query --json --max=1 --keyring=/usr/share/keyrings/ubuntu-cloudimage-keyring.gpg http://cloud-images.ubuntu.com/releases/streams/v1/com.ubuntu.cloud:released:download.sjson arch=amd64 release_codename=$release_codename ftype='disk1.img' | jq -r '.[].item_url'
```

- query all releases

```bash
release_codename='Focal Fossa'
sstream-query --json --keyring=/usr/share/keyrings/ubuntu-cloudimage-keyring.gpg http://cloud-images.ubuntu.com/releases/streams/v1/com.ubuntu.cloud:released:download.sjson arch=amd64 release_codename=$release_codename ftype='disk1.img' | jq -r '.[].version_name'
```

- [Index of /releases/streams/v1](https://cloud-images.ubuntu.com/releases/streams/v1/)
- [Ubuntu 20.04.3 LTS (Focal Fossa)](https://releases.ubuntu.com/20.04/)
- [Ubuntu 20.04 LTS (Focal Fossa) Daily Build [20211216]](https://cloud-images.ubuntu.com/focal/current/)
  - [img dl](https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img)
- [Ubuntu 20.04 LTS (Focal Fossa) [20211129]](https://cloud-images.ubuntu.com/releases/focal/release-20211129/)
  - [img dl](https://cloud-images.ubuntu.com/releases/focal/release-20211129/ubuntu-20.04-server-cloudimg-amd64.img)

## test ansible

- test with no `ansible.cfg`

```bash
ansible all --key-file ~/.ssh/id_ed25519_proxmox -i inventory -m ping
```

- restrict working directory permissions in order to use `ansible.cfg`

```bash
sudo chmod -R 770 proxmox-template
```

- add basic config to `ansible.cfg`

```bash
cat > ansible.cfg <<EOT
[defaults]
inventory = inventory
private_key_file =  ~/.ssh/id_ed25519_proxmox
EOT
```

- test with `ansible.cfg`

```bash
ansible all -m ping
```

## Proxmox cli commands

```bash
pveum role list --output-format=json | jq -r "any(.[].roleid; . == \"Automation\")"
pveam available
pveam list local
pveam list vmstore
qm list
pvesh ls /nodes/proxmox/qemu
pvesh ls /nodes/proxmox/qemu/9002/config
ls /dev/mapper # VMs-vm--{vmId}--disk--{diskIdx|cloudinit}
```

- force kill vm

```bash
VMID='9004'
ps aux | grep "/usr/bin/kvm -id $VMID" # get PID
kill -9 PID
```

- cycle clone with new user data

```bash
# local
rsync /mnt/h/source/orgs/shortpoet-ansible/proxmox-template/ansible/roles/310_proxmox_vms_create/configs/ubuntu-2004-user_data.yml proxmox:/var/lib/vz/snippets
# host
VM_ID='9999'
VM_CLONE_ID='999'
qm stop $VM_CLONE_ID && qm destroy $VM_CLONE_ID
qm clone $VM_ID $VM_CLONE_ID --name ubuntu2004-cloud-template-ansible-clone --full >/dev/null 2>&1
qm start $VM_CLONE_ID
#[How to ping in linux until host is known?](https://serverfault.com/questions/42021/how-to-ping-in-linux-until-host-is-known)
VM_IP='192.168.1.42'
GREEN='\033[0;32m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color
# waits for sshd
until nc -vzw 2 $VM_IP  22 >/dev/null 2>&1; do sleep 2; echo -e "..${MAGENTA}PING${NC}"; done; echo -e "--> ${GREEN}DONE${NC}"
# up for a few before sshd is ready
until ping -c1 $VM_IP >/dev/null 2>&1; do :; done; echo -e "--> ${GREEN}DONE${NC}"
# local & ssh command
rsync /mnt/h/source/orgs/shortpoet-ansible/proxmox-template/ansible/roles/310_proxmox_vms_create/configs/ubuntu-2004-user_data.yml proxmox:/var/lib/vz/snippets && ssh proxmox 'cycle_vm 9999 999'

```

- [ip / mac](https://github.com/xezpeleta/Ansible-Proxmox-inventory/issues/8#issuecomment-580628406)

```bash
# - get the mac address of the vm
$vmid=''
$mac=$(/usr/sbin/qm config $vmid | awk '/net0/ { print tolower($2) }' | sed -r 's/[^=]*=([0-9a-f:]*),.*/\1/g')
# - get the ip address of the vm
arp -an -i eth1 | grep $mac | cut -d' ' -f2 | sed -r 's/\((.*)\)/\1/g'
qm guest cmd 999 network-get-interfaces | jq -r '.[] | select(.name == "eth0")."ip-addresses"[] | select(."ip-address-type" == "ipv4")."ip-address"'
```

## Environment

```powershell
$env:TF_VAR_proxmox_password=$(Get-Secret -Name ProxmoxAutomation -AsPlainText)
$env:PKR_VAR_proxmox_password=$(Get-Secret -Name ProxmoxAutomation -AsPlainText)
$env:PKR_VAR_WIN_IP_LOCAL=$((Get-NetIPConfiguration | Select-Object IPv4Address -First 1).IPv4Address.IPAddress)
```

```bash
export PKR_VAR_WIN_IP_LOCAL=$(pwsh.exe -c '$ip=$(Get-NetIPConfiguration | Select-Object IPv4Address -First 1);$ip.IPv4Address.IPAddress')
export PROXMOX_AUTOMATION_PASSWORD=$(pass Homelab/proxmox/users/automation@pve)
export PKR_VAR_proxmox_password=$(pass Homelab/proxmox/users/automation@pve)
mkpasswd -m sha-512 --rounds=4096 $(pass Homelab/proxmox/users/automation@pve)
mkpasswd -m sha-512 $(pass Homelab/proxmox/users/automation@pve)
```

## git (image files 😅)

- [git rm - fatal: pathspec did not match any files](https://stackoverflow.com/questions/25458306/git-rm-fatal-pathspec-did-not-match-any-files)

```bash
git filter-branch --force --index-filter 'git rm -r --cached --ignore-unmatch terraform/iso_base/hirsute-server-cloudimg-amd64.img' --prune-empty -- --all
```

## comparing instances

- sftp
  - [How to use SFTP on a system that requires sudo for root access & ssh key based authentication?](https://unix.stackexchange.com/questions/111026/how-to-use-sftp-on-a-system-that-requires-sudo-for-root-access-ssh-key-based-a)

```bash
sftp -o stricthostkeychecking=no -o identityfile=~/.ssh/id_ed25519_proxmox notroot@192.168.1.91
# with sudo
sftp -s "sudo /usr/lib/openssh/sftp-server" -o stricthostkeychecking=no -o identityfile=~/.ssh/id_ed25519_proxmox notroot@192.168.1.42
# sftp> get /run/cloud-init/instance-data.json /run/cloud-init/instance-data-sensitive.json /etc/cloud/cloud.cfg
```

## ssh

```bash
ssh-keygen -f "/home/shortpoet/.ssh/known_hosts" -R "192.168.1.42" && ssh -o stricthostkeychecking=no -o identityfile=~/.ssh/id_ed25519_proxmox notroot@192.168.1.42
```

## dotfiles

```bash
pass Github/hamflavor-windows-pat
mkdir repos; cd repos; git clone https://github.com/shortpoet-dots/linux.git/
cd ~; chmod +x ./repos/linux/.bin/install.sh; ./repos/linux/.bin/install.sh
```

## Packer

### Windows

- [GitLab](https://grot.geeks.org/tanner/packer-windows/-/tree/bae4d5b880a080e3d1a101224c0fe65e18711771)
- [How to Extract Specific Files from Windows 10 ISO (Install.wim)](https://www.winhelponline.com/blog/extract-files-windows-10-iso-dvd-install-wim/)

```powershell
Mount-DiskImage -ImagePath C:\Users\shortpoet\Documents\disk-images\win10\Win10_21H2_English_x64.iso
# elevated
Get-WindowsImage -ImagePath e:\sources\install.wim
```
