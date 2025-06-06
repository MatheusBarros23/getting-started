terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10.0"
    }
  }

  backend "s3" {
    bucket         = "bucket-terraform-mprb-jvvc-03"
    key            = "todo-app/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
  }
}
