output "nginx_ingress_serviceLB_ip" {

  description = <<-EOD
    Public IP assigned to the LoadBalancer from where requests will be forwarded to the NGINX Ingress
    controller running inside the AKS cluster.
  EOD

  value = azurerm_public_ip.this.ip_address
}