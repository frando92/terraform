terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.68.1"
    }
  }
}
provider "proxmox" {
  insecure = true
  ssh {
    agent = true
  }
  #not using https
}

resource "proxmox_virtual_environment_vm" "k8s-cluster" {

  for_each  = { for vm in var.vm_nodes : vm.name => vm }
  vm_id     = each.value.id
  node_name = var.proxmox_app_node
  name      = join("-", slice(split("-", each.value.name), 0, 2))
  tags = ["terraform", "ubuntu", "k8s"]
  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = false
  }
  cpu {
    cores = each.value.cores
  }
  memory {
    dedicated = each.value.memory
  }
  disk {
    datastore_id = "local"
    file_id      = "local:iso/ubuntu-oracular-server-cloudimg-amd64.img"
    interface    = "scsi0"
  }
}

resource "random_password" "ubuntu_vm_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

resource "tls_private_key" "ubuntu_vm_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

output "ubuntu_vm_password" {
  value     = random_password.ubuntu_vm_password.result
  sensitive = true
}

output "ubuntu_vm_private_key" {
  value     = tls_private_key.ubuntu_vm_key.private_key_pem
  sensitive = true
}

output "ubuntu_vm_public_key" {
  value = tls_private_key.ubuntu_vm_key.public_key_openssh
}