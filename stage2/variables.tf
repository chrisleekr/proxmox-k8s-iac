
variable "proxmox_api_url" {
  description = <<-EOT
  Proxmox API URL
  i.e. https://192.168.1.100:8006/api2/json
  EOT
}

variable "proxmox_user" {
  description = "Proxmox user. i.e. root@pam"
}

variable "proxmox_password" {
  description = "Proxmox password"
}

variable "proxmox_nodes" {
  description = "Number of Kubernetes node"
  default     = 3
}

variable "ssh_key_file" {
  description = "SSH key file that add to VM"
  default     = "~/.ssh/id_rsa.pub"
}

variable "proxmox_vm_cores" {
  description = "CPU cores for VM"
  default     = 4
}

variable "proxmox_vm_memory" {
  description = "CPU memory for VM"
  default     = 4098
}

variable "proxmox_vm_disk0_storage" {
  description = "Disk 0 storage name. i.e. local-lvm"
  default     = "local-lvm"
}

variable "proxmox_vm_disk0_size" {
  description = "Disk 0 storage size. i.e. 50G"
  default     = "50G"
}

variable "proxmox_vm_disk0_ssd" {
  description = "Disk 0 ssd. 1 or 0"
  default     = "1"
}


variable "proxmox_vm_disk1_storage" {
  description = "Disk 1 storage name. i.e. local-lvm"
  default     = "local-lvm"
}

variable "proxmox_vm_disk1_size" {
  description = "Disk 1 storage size. i.e. 50G"
  default     = "100G"
}

variable "proxmox_vm_disk1_ssd" {
  description = "Disk 1 ssd. 1 or 0"
  default     = "0"
}
