terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.68.1"
    }
  }
}
provider "proxmox" {
  insecure = true # Required for self-signed certificates
}

resource "proxmox_virtual_environment_network_linux_vlan" "vlan10" {
  node_name = "proxmoxhp1"
  name      = "vmbr0.10"
  address   = "10.205.10.0/29"
}

resource "proxmox_virtual_environment_network_linux_vlan" "vlan20" {
  node_name = "proxmoxhp1"
  name      = "vmbr0.20"
  address   = "10.205.20.0/29"
}

resource "proxmox_virtual_environment_network_linux_vlan" "vlan30" {
  node_name = "proxmoxhp1"
  name      = "vmbr0.30"
  address   = "10.205.30.0/24"
}

resource "proxmox_virtual_environment_network_linux_vlan" "vlan40" {
  node_name = "proxmoxhp1"
  name      = "vmbr0.40"
  address   = "10.205.40.0/29"
}
