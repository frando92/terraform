locals {
  node       = "proxmoxhp1"
  bridge     = "vmbr0"
  iso_store  = "local" # where the ISO lives
  disk_store = "local" # where VM disks live
  iso_path   = "${local.iso_store}:iso/talos-1.10.6-nocloud-guest-agent-amd64.iso"

  vms = {
    cp1 = { mac = "02:CA:FE:00:00:02", mem = 4096, cores = 2, vm_id = 302,
      ip = "10.205.30.2"
    }
    w1 = { mac = "02:CA:FE:00:00:03", mem = 4096, cores = 2, vm_id = 303,
      ip = "10.205.30.3"
    }
    w2 = { mac = "02:CA:FE:00:00:04", mem = 4096, cores = 2, vm_id = 304,
      ip = "10.205.30.4"
    }
  }
}
