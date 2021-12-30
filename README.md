# proxmox-template

## resources

- [engonzal/ansible_role_proxmox Public](https://github.com/engonzal/ansible_role_proxmox)
- [community.general.proxmox – Proxmox inventory source](https://docs.ansible.com/ansible/latest/collections/community/general/proxmox_inventory.html#examples)
- [ansible.builtin.pip – Manages Python library dependencies](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/pip_module.html)
- [community.general.proxmox_template – management of OS templates in Proxmox VE cluster](https://docs.ansible.com/ansible/latest/collections/community/general/proxmox_template_module.html#ansible-collections-community-general-proxmox-template-module)
- [community.general.proxmox_tasks_info – Retrieve information about one or more Proxmox VE tasks](https://docs.ansible.com/ansible/latest/collections/community/general/proxmox_tasks_info_module.html#ansible-collections-community-general-proxmox-tasks-info-module)
- https://docs.ansible.com/ansible/latest/collections/community/general/proxmox_kvm_module.html#ansible-collections-community-general-proxmox-kvm-module

## get images

- [Get images](https://docs.openstack.org/image-guide/obtain-images.html)

### Push Images

```bash
ssh proxmox 'wget "http://cdimage.debian.org/cdimage/openstack/current-10/debian-10-openstack-amd64.qcow2" -P /var/lib/vz/template/iso/'
ssh proxmox 'wget "https://releases.ubuntu.com/20.04/ubuntu-20.04.3-live-server-amd64.iso" -P /var/lib/vz/template/iso/'
ssh proxmox 'wget "https://cdimage.debian.org/cdimage/release/current/amd64/iso-cd/debian-11.2.0-amd64-netinst.iso" -P /var/lib/vz/template/iso/'
ssh proxmox 'wget "http://cdimage.ubuntu.com/releases/20.04/release/ubuntu-20.04.3-live-server-arm64.iso" -P /var/lib/vz/template/iso/'
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

## Environment

```powershell
$env:TF_VAR_proxmox_password=$(Get-Secret -Name ProxmoxAutomation -AsPlainText)
$env:PKR_VAR_proxmox_password=$(Get-Secret -Name ProxmoxAutomation -AsPlainText)
$env:PKR_VAR_WIN_IP_LOCAL=$((Get-NetIPConfiguration | Select-Object IPv4Address -First 1).IPv4Address.IPAddress)
```

```bash
export WIN_IP_LOCAL=$(pwsh.exe -c '$ip=$(Get-NetIPConfiguration | Select-Object IPv4Address -First 1);$ip.IPv4Address.IPAddress')
mkpasswd -m sha-512 --rounds=4096 $(pass Homelab/proxmox/users/automation@pve)
mkpasswd -m sha-512 $(pass Homelab/proxmox/users/automation@pve)
```

## git (image files 😅)

- [git rm - fatal: pathspec did not match any files](https://stackoverflow.com/questions/25458306/git-rm-fatal-pathspec-did-not-match-any-files)

```bash
git filter-branch --force --index-filter 'git rm -r --cached --ignore-unmatch terraform/iso_base/hirsute-server-cloudimg-amd64.img' --prune-empty -- --all
```
