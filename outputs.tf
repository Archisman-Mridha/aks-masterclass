output "nginx_ingress_serviceLB_ip" {

  description = <<-EOD
    Public IP assigned to the LoadBalancer from where requests will be forwarded to the NGINX Ingress
    controller running inside the AKS cluster.
  EOD

  value = azurerm_public_ip.this.ip_address
}

output "cluster_external_dns_operator_id" {
  description = <<-EOD
    Client id of the user assigned identity which represents the external DNS operator running inside
    the cluster.
  EOD

  value = azurerm_user_assigned_identity.cluster_external_dns_operator.client_id
}