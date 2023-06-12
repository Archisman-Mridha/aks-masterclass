# Azure Kubernetes Service

AKS (Azure Kubernetes Service) is highly available, secure and fully managed Kubernetes service from Azure.

## Notes

- While creating the AKS cluster, Azure creates some default StorageClasses for us (like *`default`*, *`managed-premium`*, *`azurefile`* etc.). **Reclaim policy for these StorageClasses is "delete"** (when we delete a PV, the underlying Azure Disk will also be deleted).

- An **Azure disk cannot be mounted to multiple pods at the same time**. But in case of **a file residing in Azure File Shares** it is possible. By default, in the AKS cluster, 2 StorageClasses are created - *`azurefile`* (uses Standard LRS) and *`azurefile-premium`* (uses Premium LRS). If you want to use some other Azure File Shares tier (like Standard GRS, Standard ZRS), then you can create a custom StorageClass.

- Run these commands to **install** *`NGINX ingress controller`* inside the AKS cluster -
  ```bash
  helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx &&
    helm repo add stable https://charts.helm.sh/stable
  helm repo update

  helm install \
    -f ./kubernetes/helm/ingress-nginx.values.yaml \
    ingress-nginx ingress-nginx/ingress-nginx \
    --create-namespace --namespace ingress-nginx

  # Check status of the installation
  kubectl --namespace ingress-nginx get services -o wide -w ingress-nginx-controller
  ```

- A **domain** (for example - google.com) **is a unique name in the Domain Name system**. **With a domain, multiple DNS records** (like mail.google.com, drive.google.com etc.) **can be associated**. A *`DNS Zone`* **keeps track of all these DNS records associated with that domain**.

  > Azure doesn't have any service using which we can buy domains (**it isn't a domain registrar**), but **it can host DNS Zones for our existing domains**.

- *`Kubernetes External DNS`* - DNS records are automatically created (in the DNS Zone) when we mention them in the Ingress hostname.

  You can explore it more here - https://github.com/kubernetes-sigs/external-dns.

  Command to **create the Kubernetes secret containing Azure DNS config** (which is required by external DNS) -
  ```bash
  kubectl create secret generic azure-dns-config \
    --from-file ./kubernetes/external-dns/azure-dns.config.json
  ```

- *`Cert Manager`* is a **native Kubernetes certificate management controller**. It can help with issuing certificates from a variety of sources such as Let's Encrypt, Hashicorp Vault etc. It will **ensure that TLS certificates are up to date** and if not then **it will try to renew those certificates before expiry**.

  You can read more about Cert-Manager here - https://cert-manager.io/docs

  Command used to install Cert Manager -
  ```bash
  # TODO: Understand why this is done.
  kubectl label namespace ingress-nginx cert-manager.io/disable-validation=true

  kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.0/cert-manager.yaml
  ```

- *`Cluster Autoscaler`* -

  To test the Horizontal node autoscaler, you can use these commands -
  ```bash
  kubectl apply -f ./kubernetes/apps/whoami/deployment.yaml

  # Scale up the whoami application to 100 replicas.
  # The number of nodes will also be scaled up automatically.
  kubectl scale --replicas=100 deploy whoami

  # Scale down the whoami application to 1 replica.
  # The number of nodes will also be scaled down automatically.
  kubectl scale --replicas=1 deploy whoami
  ```

  Since **metric-server is installed by default in case of AKS** (unlike EKS), we can get started directly with Horizontal Pod Autoscaling. Run this command, to generate load for the whoami application pods and see them autoscale -
  ```
  kubectl run apache-bench -i --tty --rm --image=httpd -- ab -n 500000 -c 10000 http://whoami.default.svc.cluster.local/
  ```
  **The default scaledown period in case of HPA is 5 minutes**. Even if the load decreases, the pods will not scaledown before 5 minutes.