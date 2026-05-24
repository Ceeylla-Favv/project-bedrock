terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = var.tags
  }
}

module "vpc" {
  source       = "./modules/vpc"
  cluster_name = var.cluster_name
  tags         = var.tags
}

module "eks" {
  source       = "./modules/eks"
  cluster_name = var.cluster_name
  vpc_id       = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids
  tags         = var.tags
}

module "rds" {
  source             = "./modules/rds"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  eks_sg_id          = module.eks.node_security_group_id
  db_password        = var.db_password
  tags               = var.tags
}

module "dynamodb" {
  source = "./modules/dynamodb"
  tags   = var.tags
}

module "iam" {
  source     = "./modules/iam"
  student_id = var.student_id
  tags       = var.tags
}

module "s3_lambda" {
  source     = "./modules/s3-lambda"
  student_id = var.student_id
  tags       = var.tags
}