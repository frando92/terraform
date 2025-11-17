variable "vm_nodes" {
  type = list(object({
    name   = string
    cores    = number
    memory = number
    disk   = string
    ip     = string
    id     = number
  }))
  default = [
    {
      name   = "k8s-master-1"
      cores    = 2
      memory = 2048
      disk   = "20G"
      ip     = "10.205.30.1"
      id     = 301
    },
    {
      name   = "k8s-worker-1"
      cores    = 1
      memory = 1024
      disk   = "10G"
      ip     = "10.205.30.2"
      id     = 302
    }
  ]
}

variable "proxmox_app_node" {
  type    = string
  default = "proxmoxhp1"
}

