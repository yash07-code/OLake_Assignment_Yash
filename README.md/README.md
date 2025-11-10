# OLake Assignment - Yash Suryawanshi

## 1️⃣ Prerequisites

Before starting, ensure you have the following:

- **Cloud Provider:** Azure  
- **Terraform Version:** 1.8.0 (or your installed version)  
- **Minikube**  
- **kubectl**  
- **Helm**  
- SSH key pair (`~/.ssh/id_ed25519`)  
- Internet access from VM to download Docker, Helm, and Minikube binaries  

---

## 2️⃣ Setup Instructions

Follow these steps to deploy OLake:

### Step 1: Clone the Repository
```bash
git clone <your-repo-url>
cd OLake_Assignment_Yash

##Step 2: Configure Terraform Variables
  cp terraform/terraform.tfvars.example terraform/terraform.tfvars


##Step 3: Initialize Terraform
    cd terraform
    terraform init

##Step 4: Apply Terraform
    terraform apply

##Step 5: SSH into the VM
    ssh azureuser@<VM_PUBLIC_IP>


## Step 6: Verify Kubernetes Deployment
    kubectl get pods -n olake
    kubectl get svc -n olake

##Step 7: Access OLake UI
  Check NodePort for OLake UI service: kubectl get svc olake-ui-nodeport -n olake

  Open your browser:http://<VM_PUBLIC_IP>:<NodePort>
  
##Step8:Cleanup Instructions
    cd terraform
    terraform destroy


