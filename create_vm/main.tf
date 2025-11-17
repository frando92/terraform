terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.68.1"
    }
  }
}
provider "proxmox" {
  endpoint = "https://proxmoxhp1:8006/"  # Replace with your Proxmox server IP/hostname
  insecure = true # Required for self-signed certificates
}
 
resource "proxmox_virtual_environment_vm" "debian_vm" {
  node_name="proxmoxhp1"
  disk {
    datastore_id = "local"
    file_id      = "local:iso/alpine-standard-3.20.3-x86_64.iso"
    interface    = "scsi0"
  }
}

