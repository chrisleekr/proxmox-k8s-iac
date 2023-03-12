locals {
  worker_names   = formatlist("k8s-%s", range(0, var.proxmox_nodes))
  worker_ips     = formatlist("192.168.1.15%s", range(0, var.proxmox_nodes))
  worker_gateway = "192.168.1.1"
}

resource "proxmox_vm_qemu" "worker_nodes" {
  count = var.proxmox_nodes
  name  = "${local.worker_names[count.index]}.cluster"
  #  The name of the Proxmox Node on which to place the VM.
  target_node = "homelab-pve"
  desc        = "HomeLab Kubernetes node"

  clone = "ubuntu-2204-cloudinit-template"

  qemu_os  = "l26" # Linux, Kernel 2.6
  os_type  = "cloud-init"
  cores    = var.proxmox_vm_cores
  sockets  = "1"
  cpu      = "host"
  memory   = var.proxmox_vm_memory
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"

  // scsi0
  disk {
    size    = var.proxmox_vm_disk0_size
    type    = "scsi"
    storage = var.proxmox_vm_disk0_storage
    ssd     = var.proxmox_vm_disk0_ssd
  }

  // scsi1
  disk {
    size    = var.proxmox_vm_disk1_size
    type    = "scsi"
    storage = var.proxmox_vm_disk1_storage
    ssd     = var.proxmox_vm_disk1_ssd
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  # cloud-init settings
  # adjust the ip and gateway addresses as needed
  ipconfig0 = "ip=${local.worker_ips[count.index]}/24,gw=${local.worker_gateway}"
  sshkeys   = file("${var.ssh_key_file}")

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
    ]
  }

  timeouts {
    create = "10m"
    update = "5m"
    delete = "5m"
  }
}
