variable "vpc_id" {}
variable "private_subnet_ids" {}
variable "eks_sg_id" {}
variable "db_password" { sensitive = true }
variable "tags" { default = {} }