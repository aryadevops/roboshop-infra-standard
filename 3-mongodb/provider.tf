terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.50.0"
    }
  }

    backend "s3" {
    bucket   = "roboshop-infra-buck"
    key = "mongodb"
    region = "us-east-1"
    dynamodb_table = "roboshop-infra-locking"
  }
}



# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}