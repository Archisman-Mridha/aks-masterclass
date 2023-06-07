// This is dynamically created by AKS, when we create the "nginx" PVC.
data "azurerm_storage_share" "this" {
  name = "pvc-b01cdf94-3204-4476-a1a4-754b1cf765d3"
  storage_account_name = "fd0c49f4dd05c4774a27710"
}

resource "azurerm_storage_share_file" "this" {
  name = "file1.html"
  source = "${path.module}/file1.html"

  storage_share_id = data.azurerm_storage_share.this.id
}