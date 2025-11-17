provider "proxmox" {
  pm_tls_insecure = true
}

variable "node_name" {
  default = "proxmoxhp1"
}

variable "vm_count" {
  default = 3
}

resource "proxmox_vm_qemu" "talos_nodes" {
  count       = var.vm_count
  name        = "talos-node-${count.index}"
  target_node = var.node_name
  vmid        = 302 + count.index

  #clone = "talos-template" # OPTIONAL: If using a pre-configured template

  os_type = "cloud-init" # required for Talos if using cloud-init method

  #ipconfig0 = "gw=10.205.30.1,ip=10.205.30.${2 + count.index}/29"

  cpu {
    sockets = 1
    cores   = 2
  }
  memory   = 2048
  scsihw   = "virtio-scsi-pci"
  bootdisk = "virtio0"

  disk {
    slot = "sata0"
    type = "cdrom"
    iso  = "local:iso/talos-1.10.5-nocloud.iso"
  }

  disk {
    slot    = "virtio0"
    size    = "10G"
    type    = "disk"
    storage = "local"
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }


  boot = "cdn"

  agent = 0

  cicustom = "user=local:snippets/talos-${count.index}.yaml"
}

