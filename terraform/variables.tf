variable "region" {
  default = "us-east-1"
}

variable "cluster_name" {
  default = "project-bedrock-cluster"
}

variable "vpc_name" {
  default = "project-bedrock-vpc"
}

variable "student_id" {
  description = "Your student ID for unique bucket naming"
  type        = string
}

variable "db_password" {
  description = "Master password for RDS instances"
  type        = string
  sensitive   = true
}

variable "tags" {
  default = {
    Project = "karatu-2025-capstone"
  }
}# pipeline test
