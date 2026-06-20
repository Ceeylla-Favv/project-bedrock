terraform {
  backend "s3" {
    bucket = "project-bedrock-tfstate-977145922444"
    key    = "project-bedrock/terraform.tfstate"
    region = "us-east-1"
  }
}

