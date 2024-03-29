terraform {
  backend "s3" {
    bucket = "wordle-solver-tfstate"
    key    = "wordle-solver.tfstate"
    region = "us-east-2"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

provider "aws" {
  alias  = "acm"
  region = "us-east-1"
}

data "aws_region" "current" {}
