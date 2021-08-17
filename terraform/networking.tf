# Create a resource group
resource "azurerm_resource_group" "Terraform-test" {
  name     = "ELK-monitor"
  location = "eastus2"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "VN1" {
  name                = "${var.vmprefix1}VN1"
  resource_group_name = azurerm_resource_group.Terraform-test.name
  location            = azurerm_resource_group.Terraform-test.location
  address_space       = ["10.10.0.0/16"]
}

# Create a Subnet based on VNet receintly created
resource "azurerm_subnet" "SubN1" {
  name                 = "Subnet1"
  resource_group_name  = azurerm_resource_group.Terraform-test.name
  virtual_network_name = azurerm_virtual_network.VN1.name
  address_prefix       = "10.10.10.0/24"
}

resource "azurerm_public_ip" "PubIP" {
  name                = "${var.vmprefix1}PublicIp1"
  resource_group_name = azurerm_resource_group.Terraform-test.name
  location            = azurerm_resource_group.Terraform-test.location
  allocation_method   = "Static"

  tags = {
    environment = "staging"
    # environment = "Production"
  }
}

resource "azurerm_network_interface" "main" {
  name                = "${var.vmprefix1}-nic"
  location            = azurerm_resource_group.Terraform-test.location
  resource_group_name = azurerm_resource_group.Terraform-test.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.SubN1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.PubIP.id
  }
}

#General Security Group
resource "azurerm_network_security_group" "mon-nsg" {
  name                = "${azurerm_resource_group.Terraform-test.name}-SecurityGroup"
  location            = "${azurerm_resource_group.Terraform-test.location}"
  resource_group_name = "${azurerm_resource_group.Terraform-test.name}"

  security_rule {
    name                        = "All-22"
    priority                    = "1001"
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "tcp"
    source_port_range           = "*"
    destination_port_range      = "22"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "All-80"
    priority                    = "100"
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "tcp"
    source_port_range           = "*"
    destination_port_range      = "80"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "All-443"
    priority                    = "101"
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "tcp"
    source_port_range           = "*"
    destination_port_range      = "443"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "kibana"
    priority                    = "102"
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "tcp"
    source_port_range           = "*"
    destination_port_range      = "5601"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "elasticsearch"
    priority                    = "103"
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "tcp"
    source_port_range           = "*"
    destination_port_range      = "9200"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }

  security_rule {
    name                        = "logstash"
    priority                    = "104"
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "tcp"
    source_port_range           = "*"
    destination_port_range      = "5044"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }
}