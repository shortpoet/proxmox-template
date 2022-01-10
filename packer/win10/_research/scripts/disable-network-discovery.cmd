@REM [samgabrail/packer-terraform-vmware - Public](https://github.com/samgabrail/packer-terraform-vmware/blob/master/packer-vsphere-iso-windows/scripts/disable-network-discovery.cmd)
reg ADD HKLM\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff /f
netsh advfirewall firewall set rule group="Network Discovery" new enable=No