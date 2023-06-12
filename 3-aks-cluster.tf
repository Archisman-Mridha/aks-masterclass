resource "azurerm_kubernetes_cluster" "this" {
  name = "demo"

  resource_group_name = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location

  // In Azure, a node-pool means a group of worker nodes
  default_node_pool {
    name = "default"

    node_count = 1
    vm_size = "Standard_A2_v2"

    // Cluster Autoscaling
    enable_auto_scaling = true
    min_count = 1
    max_count = 5
  }

  identity {
    // NOTE - Using system-assigned managed identity instead of service principal
    // makes it easy for us to use Azure Container Registry.

    type = "UserAssigned"

    // Associate the user assigned identity representing Kubernetes external DNS, to the
    // virtual machine scaleset created for this cluster.
    identity_ids = [ azurerm_user_assigned_identity.cluster_external_dns_operator.id ]
  }
  kubelet_identity {
    user_assigned_identity_id = azurerm_user_assigned_identity.cluster_external_dns_operator.id

    client_id = azurerm_user_assigned_identity.cluster_external_dns_operator.client_id
    object_id = azurerm_user_assigned_identity.cluster_external_dns_operator.principal_id
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

  linux_profile {
    admin_username = "archi"

    ssh_key {
      key_data = tls_private_key.this.public_key_openssh
    }
  }
}

resource "local_file" "kubeconfig" {
  filename = "outputs/kubeconfig.yaml"
  content = azurerm_kubernetes_cluster.this.kube_config_raw
}