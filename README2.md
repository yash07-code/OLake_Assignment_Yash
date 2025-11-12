# 🌩️ OLake Infrastructure Deployment using Terraform on Microsoft Azure

## 📘 Overview
This project demonstrates **Infrastructure as Code (IaC)** using **Terraform** to provision and manage cloud infrastructure on **Microsoft Azure**.  
It automates the creation of essential Azure resources like **Resource Groups**, **Storage Accounts**, **Virtual Networks**, and **Virtual Machines**, ensuring consistent, repeatable deployments.

---

## 🧠 Objective
The goal of this assignment is to:
- Automate infrastructure provisioning using **Terraform**.
- Implement **modular, reusable, and scalable** Terraform configurations.
- Manage Azure resources efficiently through declarative IaC.
- Understand and demonstrate **state management, variables, and outputs** in Terraform.

---

## ⚙️ Tech Stack
- **Terraform v1.9+**
- **Microsoft Azure Cloud**
- **Azure CLI**
- **Linux (Ubuntu 24.04)**
- **Git & GitHub**

---

## 🏗️ Project Structure

OLake_Assignment_Yash/
│
├── terraform/
│ ├── main.tf # Main configuration file defining Azure resources
│ ├── variables.tf # Input variables
│ ├── outputs.tf # Outputs like IPs or resource names
│ ├── provider.tf # Azure provider configuration
│ ├── terraform.tfvars # Actual values for variables
│ ├── .gitignore # Ignored Terraform files and state
│ └── README.md # (this file)
└── screenshots/
