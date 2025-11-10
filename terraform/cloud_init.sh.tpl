#cloud-config
package_update: true
package_upgrade: true
runcmd:
  - apt-get update -y
  - apt-get install -y apt-transport-https ca-certificates curl software-properties-common conntrack
  - curl -fsSL https://get.docker.com -o get-docker.sh
  - sh get-docker.sh
  - usermod -aG docker azureuser
  - curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
  - chmod +x kubectl && mv kubectl /usr/local/bin/
  - curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
  - install minikube-linux-amd64 /usr/local/bin/minikube
  - su - azureuser -c "minikube start --driver=docker --cpus=3 --memory=6144"
  - su - azureuser -c "minikube addons enable ingress"
  - su - azureuser -c "minikube addons enable storage-provisioner"
  - curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
  - su - azureuser -c "helm repo add olake https://datazip-inc.github.io/olake-helm"
  - su - azureuser -c "helm repo update"
  - su - azureuser -c "helm upgrade --install olake olake/olake --namespace olake --create-namespace --set ingress.enabled=true --set service.port=8000"
