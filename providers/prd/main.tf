terraform {
  backend "s3" {
    bucket                  = "terraform-obytes"
    key                     = "aws/us-east1/prd/terraform.tfstate"
    region                  = "us-east-1"
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "obytes"
  }

  required_version = "= 0.13.0"
}

provider "github" {
  version      = "= 2.9.2"
  organization = data.terraform_remote_state.github.outputs.organization
  token        = data.terraform_remote_state.github.outputs.token
}

provider "aws" {
  region  = var.region
  profile = var.aws_profile
  version = "= 3.3.0"
}

provider "cloudflare" {
  version    = "~> 2.6.0"
  api_token  = var.cf_token
  account_id = var.cf_account_id
}

data "terraform_remote_state" "github" {
  backend = "s3"

  config = {
    bucket                  = "terraform-obytes"
    key                     = "github/terraform.tfstate"
    region                  = "us-east-1"
    profile                 = "obytes"
    shared_credentials_file = "~/.aws/credentials"
  }
}

data "terraform_remote_state" "aws_us_east1_adm" {
  backend = "s3"

  config = {
    bucket                  = "terraform-obytes"
    key                     = "aws/us_east1/adm/terraform.tfstate"
    region                  = "us-east-1"
    profile                 = "obytes"
    shared_credentials_file = "~/.aws/credentials"
  }
}

data "aws_region" "current" {
}

locals {
  prefix = "${var.env}-${var.project_name}-${replace(data.aws_region.current.name, "-", "")}"

  common_tags = {
    env          = var.env
    project_name = var.project_name
    region       = var.region
  }
}

