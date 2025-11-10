output "vm_public_ip" {
  description = "Public IP of the VM"
  value       = azurerm_public_ip.pip.ip_address
}

output "vm_id" {
  description = "Azure VM ID"
  value       = azurerm_linux_virtual_machine.vm.id
}

output "ssh_connection_string" {
  value = "ssh ${var.admin_username}@${azurerm_public_ip.pip.ip_address}"
}
