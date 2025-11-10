variable "location" {
  type    = string
  default = "eastus"
}

variable "resource_group_name" {
  type    = string
  default = "olake-rg"
}

variable "vm_name" {
  type    = string
  default = "olake-vm"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to your SSH public key (e.g. ~/.ssh/id_ed25519.pub)."
  default     = "/home/yash/.ssh/id_ed25519.pub"
}

variable "vm_size" {
  type    = string
  default = "Standard_D4s_v3" # 4 vCPU, 16GB RAM (meet/exceed requirement)
}

variable "disk_size_gb" {
  type    = number
  default = 50
}

variable "olake_ui_port" {
  type    = number
  default = 8000
}

variable "use_cloud_init" {
  type    = bool
  default = true
}

# For option B (helm provider approach) you may need to set where kubeconfig will be copied
variable "local_kubeconfig_path" {
  type    = string
  default = ""
}

