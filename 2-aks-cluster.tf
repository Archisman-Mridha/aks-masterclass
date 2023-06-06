resource "azurerm_kubernetes_cluster" "this" {
  name = "demo"

  resource_group_name = azurerm_resource_group.this.name
  location = azurerm_resource_group.this.location

  // In Azure, a node-pool means a group of worker nodes
  default_node_pool {
    name = "default"

    node_count = 1
    vm_size = "Standard_A2_v2"
  }

  // Using system-assigned managed identity instead of service principal
  // to avoid the container-registry related issue.
  identity {
    type = "SystemAssigned"
  }

  role_based_access_control_enabled = true

  dns_prefix = "demo-cluster"
  // Use azure network plugin for Kubernetes networking.
  network_profile {
    network_plugin = "azure"
  }

  // I used this command - "az aks get-versions --location centralindia --output table"
  // to get the supported Kubernetes versions in the current location.
  kubernetes_version = "1.26.3"
}

resource "local_file" "kubeconfig" {
  filename = "outputs/kubeconfig.yaml"
  content = azurerm_kubernetes_cluster.this.kube_config_raw
}