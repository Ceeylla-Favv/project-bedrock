terraform {
  backend "s3" {
    bucket = "project-bedrock-tfstate-904233100204"
    key    = "project-bedrock/terraform.tfstate"
    region = "us-east-1"
  }
}

