# my-gradleproject
# Project Name - 

## Introduction

This project aims to build a highly available and scalable microservices application by creating a multi-master Kubernetes cluster using kubeadm. The cluster will be created using 3 Master nodes and 3 Worker nodes. The application will be monitored using Prometheus and Grafana. This repository contains Terraform code to deploy resources on your AWS account. Terraform is an Infrastructure as Code (IaC) tool that allows you to define and manage infrastructure resources using code. This README provides step-by-step instructions on how to execute the Terraform code in this project to deploy resources on your AWS account.

![Simple gradle hello world java](Architectural-Diagram.png)


## Tech Stack used

Infrastructure as code (IAC) – Terraform

Cloud infrastructure - AWS core services

Version Control System (VCS) – Github

Configuration Management- Ansible

Monitoring- Prometheus and Grafana

High Availability- HAProxy


## Prerequisites

Before you begin, make sure you have the following prerequisites:

1. An AWS account - You'll need an active AWS account to deploy resources using this Terraform code.
2. AWS CLI - Install the AWS Command Line Interface (CLI) on your local machine and configure it with your AWS credentials.
3. Terraform - Install Terraform on your local machine. You can download it from the official website (https://www.terraform.io/downloads.html) and follow the installation instructions.
4. Git - Install Git on your local machine to clone this repository.


## Deployment Steps

Follow these steps to deploy resources on your AWS account using Terraform:


### Step 1: Clone the Repository

Clone this GitHub repository to your local machine using the following command:

```bash
git clone https://github.com/CloudHight/simple-gradle-HELLO-WORLD-JAVA.git
```


## Step 2: Navigate to the Project Directory

Change your working directory to the cloned repository:

```bash
cd simple-gradle-HELLO-WORLD-JAVA/
```


## Step 3: Set your values in the my-credentials.tfvars file in other to spin up the infrastructure in your AWS account

Important:
Before applying the Terraform configuration, ensure that you update the following variables with your own values in the my-credentials.tfvars file:

```bash
project-name                  = ""
profile-name                  = ""
region                        = ""
vpc_instance_tenancy          = "default"
all-cidr                      = "0.0.0.0/0"
cidr_block_vpc                = ""
pub_sn1_cidr_block            = ""
pub_sn2_cidr_block            = ""
pub_sn3_cidr_block            = ""
priv_sn1_cidr_block           = ""
priv_sn2_cidr_block           = ""
priv_sn3_cidr_block           = ""
az1                           = ""
az2                           = ""
az3                           = ""
instance_type2                = "t2.medium"
instance_type                 = "t2.micro"
ami-redhat                    = ""
ubuntu-ami                    = ""
instance-count                = 3
domain_name                   = "YOUR_DOMAIN"
domain_name2                  = "*.YOUR_DOMAIN"
grafana_domain_hosted_zone    = "grafana.YOUR_DOMAIN"
prometheus_domain_hosted_zone = "prometheus.YOUR_DOMAIN"
stage_domain_hosted_zone      = "stage.YOUR_DOMAIN"
prod_domain_name              = "prod.YOUR_DOMAIN"
```


## Step 4: Initialize Terraform

Run the following command to initialize Terraform and download the necessary providers:

```bash
terraform init
```


## Step 5: Plan the Deployment

Run the following command to see what changes Terraform will apply without actually deploying anything:

```bash
terraform plan -var-file my-credentials.tfvars
```

Review the output to ensure that Terraform will create the desired resources with the expected changes.


## Step 6: Deploy Resources

If everything looks good in the plan, proceed with deploying the resources:

```bash
terraform apply -var-file my-credentials.tfvars
```

You will be prompted to confirm the deployment. Type yes and press Enter to proceed.

```Note: After finishing the preceding command and process, wait for approximately 10 minutes to allow all of the playbooks to finish executing. Then, in order to view the application, enter your domain name into your browser. You can now start configuring Jenkins to deploy the application continually.```


Follow the step by step guides on confluence:

[How to generate Slack Token](https://cloudhight.atlassian.net/wiki/spaces/CTS/pages/818282587/How+to+generate+Slack+Token)

[Setting up Jenkins-Server page](https://cloudhight.atlassian.net/wiki/spaces/CTS/pages/818544641/Setting+up+Jenkins-Server) to continually deploy updates into your cluster.


## Step 7: Clean Up (Optional)

```bash
terraform destroy -var-file my-credentials.tfvars
```

You will be prompted to confirm the destruction. Type yes and press Enter to proceed.

If you encounter any issues or have questions, please feel free to open an issue in this repository. Happy coding!