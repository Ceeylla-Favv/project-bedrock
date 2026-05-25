output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_name" {
  value = var.cluster_name
}

output "region" {
  value = var.region
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "assets_bucket_name" {
  value = module.s3_lambda.bucket_name
}

output "dev_access_key_id" {
  value = module.iam.dev_access_key_id
}

output "dev_secret_access_key" {
  value     = module.iam.dev_secret_access_key
  sensitive = true
}

output "dev_console_password" {
  value     = module.iam.dev_console_password
  sensitive = true
}