resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    project = "olake-assignment"
    owner   = "Yash"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.resource_group_name}-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.resource_group_name}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.vm_name}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "OLAKE-UI"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = tostring(var.olake_ui_port)
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_name}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_public_ip" "pip" {
  name                = "${var.vm_name}-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    purpose = "olake-access"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.vm_name
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = var.vm_size
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.nic.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.disk_size_gb
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  # SSH key
  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  # cloud-init template rendered below
  custom_data = base64encode(templatefile("${path.module}/cloud_init.sh.tpl", {
    admin_user = var.admin_username,
    olake_port = var.olake_ui_port
  }))

  tags = {
    role    = "olake-minikube"
    project = "olake-assignment"
  }
}

# Associate NSG to NIC
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Wait until VM is ready (simple example)
resource "null_resource" "wait_for_ssh" {
  depends_on = [azurerm_linux_virtual_machine.vm]

  provisioner "local-exec" {
    command = "echo VM ${azurerm_public_ip.pip.ip_address} created."
  }
}

# Option A: remote-exec to run helm install on the VM (simpler)
#esource "null_resource" "helm_remote_install" {
  #depends_on = [azurerm_linux_virtual_machine.vm]

  #connection {
   # type        = "ssh"
    ##host        = azurerm_public_ip.pip.ip_address
   ## user        = var.admin_username
   # private_key = file(replace(var.ssh_public_key_path, ".pub", ""))
   # timeout     = "5m" ##
  #}

  #provisioner "remote-exec" {
   # inline = [
      # Add OLake Helm repo and update
     # "helm repo add olake https://datazip-inc.github.io/olake-helm || true",
      #"helm repo update",

      # Copy local values.yaml (Ingress, port 8000) into VM
     # "cat > /home/${var.admin_username}/olake-values.yaml <<'EOF'\n${file("${path.module}/../values.yaml")}\nEOF",

      # Deploy OLake into Minikube
     # "helm upgrade --install olake olake/olake -f /home/${var.admin_username}/olake-values.yaml --namespace olake --create-namespace"
   # ]
 # }
#}##
