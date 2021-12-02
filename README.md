# Agenda - staff-DE-CT

1. Setup Terraform code to deploy VM and AKS.
2. Deploy AKS ( 1 node with 2 VCPU, 8 GB RAM).
3. Deploy a webserver on AKS and get it exposed.

Create a "service principal" before proceeding.

```bash
$ az ad sp create-for-rbac --name ashishsp --role Contributor -- already created in Active directory
```


## 1. Setup Terraform code to deploy VM and AKS.
```bash
$ cd vm
```

### Provide ENV variables in "terraform.tfvars"
```bash
ARM_SUBSCRIPTION_ID  = ""
ARM_TENANT_ID        = ""
ARM_CLIENT_ID        = ""
ARM_CLIENT_SECRET    = ""
```

Note: If working on "git bash" on windows, run the following command to add terraform to the PATH.

```bash
$ export PATH="/c/terraform_1.0.11_windows_amd64/:$PATH"
```

### Start the terraform process.
```bash
$ terraform init
$ terraform validate
$ terraform plan -out out.plan
$ terraform apply out.plan
```

Note: The process will take approximately 1min or so.

### Get the "Public IP" of the VM.
```bash
$ cat terraform.tfstate | grep public_ip_address
```

### Login to VM
```bash
$ ssh -i myvmkey.pem azureuser@IP
```

### Install "az cli" on VM 
```bash
$ curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```
### Login to "az cli" from VM
```bash
$ az login
```

### Install "terraform" on VM

```bash
$ sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
$ curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
$ sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
$ sudo apt-get update && sudo apt-get install terraform
```
## 2. Deploy AKS ( 1 node with 2 VCPU, 8 GB RAM).
```bash
$ cd aks
```
### Provide ENV variables in "terraform.tfvars"
```bash
ARM_SUBSCRIPTION_ID  = ""
ARM_TENANT_ID        = ""
ARM_CLIENT_ID        = ""
ARM_CLIENT_SECRET    = ""
```
### Start the terraform process.
```bash
$ terraform init
$ terraform validate
```

### Create "SSH key" from portal and download the "private key"
Note: Copy the "public key" contents from portal to the following file.
```bash
$ touch id_rsa.pub
```

```bash
$ terraform plan -out out.plan
$ terraform validate
$ terraform apply out.plan
```

### Install "kubectl" on "aks".
```bash
$ curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
$ sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
$ kubectl version --client
```

### Go to cluster on "portal" OR just run the following command:
Note: MUST RUN before "kubectl apply"
```bash
$ az aks get-credentials --resource-group myaksResourceGroupde --name k8stest
```

### Verify the node status of the cluster
```bash
kubectl get nodes
```

## 3. Deploy a webserver on AKS and get it exposed.
```bash
$ wget https://raw.githubusercontent.com/kubernetes/website/main/content/en/examples/service/networking/run-my-nginx.yaml

$ wget https://raw.githubusercontent.com/kubernetes/website/main/content/en/examples/service/networking/nginx-svc.yaml
```
### Now, change the "spec" of "nginx-svc.yaml" ---> type: LoadBalancer (above ports)
```bash
$ kubectl apply -f nginx-svc.yaml

$ kubectl apply -f run-my-nginx.yaml

$ kubectl get pods

$ kubectl get svc
```

Get the IP and go to the browser to confirm.
