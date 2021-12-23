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
