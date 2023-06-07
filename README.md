# Azure Kubernetes Service

AKS (Azure Kubernetes Service) is highly available, secure and fully managed Kubernetes service from Azure.

## Notes

- While creating the AKS cluster, Azure creates some default StorageClasses for us (like *`default`*, *`managed-premium`*, *`azurefile`* etc.). **Reclaim policy for these StorageClasses is "delete"** (when we delete a PV, the underlying Azure Disk will also be deleted).

- An **Azure disk cannot be mounted to multiple pods at the same time**. But in case of **a file residing in Azure File Shares** it is possible. By default, in the AKS cluster, 2 StorageClasses are created - *`azurefile`* (uses Standard LRS) and *`azurefile-premium`* (uses Premium LRS). If you want to use some other Azure File Shares tier (like Standard GRS, Standard ZRS), then you can create a custom StorageClass.