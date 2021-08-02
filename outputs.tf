output "instance_ip_addr" {
  value = "${azurerm_public_ip.PubIP.ip_address}"
  description = "The VM IP "
}