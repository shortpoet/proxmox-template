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

- [Ubuntu 20.04 LTS (Focal Fossa) Daily Build [20211216]](https://cloud-images.ubuntu.com/focal/current/)

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
