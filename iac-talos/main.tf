provider "proxmox" {
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "talos" {
  for_each    = local.vms
  name        = "talos-${each.key}"
  vmid        = each.value.vm_id
  target_node = local.node

  onboot = true
  agent  = 1 # enable QEMU guest agent if your ISO supports it
  cpu {
    cores = each.value.cores
  }
  memory = each.value.mem
  scsihw = "virtio-scsi-pci"

  # Disk on scsi0 (32G is fine for testing; bump as needed)
  boot = "order=ide2;scsi1;scsi2"

  # Boot from ISO on ide2
  disks {
    ide {
      ide2 {
        cdrom {
          iso = local.iso_path
        }
      }
    }
    scsi {
      scsi1 {
        cloudinit {
          storage = local.disk_store
        }
      }
      scsi2 {
        disk {
          storage = local.disk_store
          size    = "32G"
        }
      }
    }
  }

  # Network (virtio on vmbr0) with fixed MACs
  network {
    id      = 0
    model   = "virtio"
    bridge  = local.bridge
    macaddr = each.value.mac
    tag     = 30
  }

  # Serial console helps Proxmox UI console work nicely
  serial {
    id   = 0
    type = "socket"
  }
  vga {
    type = "virtio"
  }

  # Cloud-init configuration
  ciuser     = "talos"
  cipassword = "talos"
  ipconfig0  = "ip=${each.value.ip}/24,gw=10.205.30.1"
}
