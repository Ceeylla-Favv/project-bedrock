# Project Bedrock — InnovateMart EKS Deployment

> Cloud DevOps Engineer Capstone — karatu-2025-capstone

A production-grade microservices deployment on AWS EKS for InnovateMart Inc., provisioned entirely via Terraform with a fully automated CI/CD pipeline.

---

## Table of Contents

- [Architecture Overview](#architecture-overview)
- [Prerequisites](#prerequisites)
- [Repository Structure](#repository-structure)
- [Infrastructure Deployment](#infrastructure-deployment)
- [Application Deployment](#application-deployment)
- [CI/CD Pipeline](#cicd-pipeline)
- [Developer Access](#developer-access)
- [Observability](#observability)
- [Serverless Extension](#serverless-extension)
- [Accessing the Application](#accessing-the-application)
- [Grading Information](#grading-information)
- [Cost Management](#cost-management)
- [Tear Down](#tear-down)


---

## Architecture Overview

| Component | Resource | Value |
|----------|----------|-------|
| Cloud provider | AWS | us-east-1 |
| EKS cluster | project-bedrock-cluster | v1.34 |
| VPC | project-bedrock-vpc | 10.0.0.0/16 |
| App namespace | retail-app | 10 microservices |
| MySQL | RDS MySQL 8.0 | bedrock-mysql |
| PostgreSQL | RDS PostgreSQL 15 | bedrock-postgres |
| NoSQL | DynamoDB | bedrock-retail-catalog |
| Assets bucket | S3 | bedrock-assets-aalt-soe-025-4343 |
| Lambda | Python 3.12 | bedrock-asset-processor |
| Domain | DuckDNS | innovatemart-inc.duckdns.org |

### Network Layout

- 2 public subnets across AZ-1 and AZ-2 (10.0.0.0/24, 10.0.1.0/24)
- 2 private subnets across AZ-1 and AZ-2 (10.0.10.0/24, 10.0.11.0/24)
- NAT gateway in public AZ-1
- Internet gateway for public subnet routing
- Application Load Balancer spanning both public subnets
- RDS deployed only in private subnets

---

## Prerequisites

Install required tools:
```
aws --version  
terraform --version  
kubectl version --client  
eksctl version  
helm version  
```
Configure AWS credentials:
```
aws configure  
Region: us-east-1  
```
---

## Repository Structure
```
project-bedrock/  
├── terraform/  
│   ├── main.tf  
│   ├── variables.tf  
│   ├── outputs.tf  
│   ├── backend.tf  
│   └── modules/  
│       ├── vpc/  
│       ├── eks/  
│       ├── rds/  
│       ├── dynamodb/  
│       ├── iam/  
│       └── s3-lambda/  
├── k8s/  
│   └── manifests/  
│       ├── ingress.yaml  
│       └── rbac.yaml  
├── helm/  
│   └── values.yaml  
├── lambda/  
│   ├── handler.py  
│   └── handler.zip  
├── .github/  
│   └── workflows/  
│       └── terraform.yml  
├── grading.json  
└── README.md  
```
---

## Infrastructure Deployment

### Create Remote State Bucket
```
aws s3api create-bucket \
  --bucket project-bedrock-tfstate-YOUR_ACCOUNT_ID \
  --region us-east-1

aws s3api put-bucket-versioning \
  --bucket project-bedrock-tfstate-YOUR_ACCOUNT_ID \
  --versioning-configuration Status=Enabled
```
---

### Configure Variables

Create terraform/terraform.tfvars:

student_id  = "Student ID"  
db_password = "Password"  

---

### Deploy Infrastructure
```
cd terraform  
terraform init  
terraform plan -var-file="terraform.tfvars"  
terraform apply -var-file="terraform.tfvars" -auto-approve  
```
---

### Connect kubectl
```
aws eks update-kubeconfig \
  --region us-east-1 \
  --name project-bedrock-cluster  

kubectl get nodes  
```
---

## Application Deployment

### Install AWS Load Balancer Controller
```
eksctl utils associate-iam-oidc-provider \
  --region us-east-1 \
  --cluster project-bedrock-cluster \
  --approve  
```
---

### Deploy Application
```
kubectl create namespace retail-app  

helm upgrade --install retail-store \
  oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart \
  --namespace retail-app \
  --values helm/values.yaml \
  --wait --timeout 10m  
```
---

### Apply Kubernetes Manifests
```
kubectl apply -f k8s/manifests/ingress.yaml  
kubectl apply -f k8s/manifests/rbac.yaml  
```
---

## CI/CD Pipeline

Pull Request → terraform plan  
Merge → terraform apply  

Required GitHub Secrets:

AWS_ACCESS_KEY_ID  
AWS_SECRET_ACCESS_KEY  
STUDENT_ID  
DB_PASSWORD  

---

## Developer Access

IAM user: bedrock-dev-view  
```
aws eks update-kubeconfig \
  --region us-east-1 \
  --name project-bedrock-cluster  

kubectl get pods -n retail-app  
```
---

## Observability

EKS logs: /aws/eks/project-bedrock-cluster  
Container logs: CloudWatch Container Insights  

---

## Serverless Extension

S3 upload triggers Lambda function:

aws s3 cp product.jpg s3://bedrock-assets-aalt-soe-025-4343/  
aws logs tail /aws/lambda/bedrock-asset-processor --since 2m  

---

## Accessing the Application

https://innovatemart-inc.duckdns.org  
http://innovatemart-inc.duckdns.org  

---

## Cost Management

### Scale Down
```
aws eks update-nodegroup-config \
  --cluster-name project-bedrock-cluster \
  --nodegroup-name project-bedrock-cluster-nodes \
  --scaling-config minSize=0,maxSize=4,desiredSize=0  
```
### Scale Up
```
aws eks update-nodegroup-config \
  --cluster-name project-bedrock-cluster \
  --nodegroup-name project-bedrock-cluster-nodes \
  --scaling-config minSize=2,maxSize=4,desiredSize=4  
```
---

## Tear Down
```
kubectl delete namespace retail-app  
cd terraform  
terraform destroy -var-file="terraform.tfvars" -auto-approve  
```
---

## Tags

Project: karatu-2025-capstone