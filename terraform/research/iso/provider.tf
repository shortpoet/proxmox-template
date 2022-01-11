# provider "proxmox" {
#   pm_api_url = "https://proxmox-server01.example.com:8006/api2/json"
# }
provider "proxmox" {
  pm_api_url      = var.proxmox_host["pm_api_url"]
  pm_user         = var.proxmox_host["pm_user"]
  pm_tls_insecure = true
}
