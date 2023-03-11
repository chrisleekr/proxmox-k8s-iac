locals {
  kubespray_inventory = templatefile("${path.module}/templates/inventory.tpl", {
    workers_user  = "ubuntu"
    workers_names = local.worker_names
    workers_ips   = local.worker_ips
  })
}

resource "local_file" "inventory" {
  content  = local.kubespray_inventory
  filename = "../stage3/inventories/inventory.yml"
}
