terraform {
  cloud {
    organization = "chrisleekr"

    workspaces {
      name = "proxmox-k8s-iac"
    }
  }
}
