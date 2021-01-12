# ----------------------------------------------------------------------------------------------------------------------
# Terraform and AWS Provider blocks
# ----------------------------------------------------------------------------------------------------------------------
terraform {
  # This module is now only being tested with Terraform 0.13.x.
  required_version = ">= 0.13.0"
}

provider "aws" {
  region  = var.region
  profile = var.aws_profile
  version = "= 3.3.0"
}
# ----------------------------------------------------------------------------------------------------------------------
# Locals and Data Sources
# ----------------------------------------------------------------------------------------------------------------------
locals {

  common_tags = {
    project_name = var.project_name
  }
}

data "aws_region" "current" {

}

data "aws_caller_identity" "current" {

}

data "aws_kms_alias" "secrets_manager" {
  name = "alias/aws/secretsmanager"
}
# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY ECS EC2 Cluster ON AWS
# The below module would prepare the required infrastructure to host Boomi container.
# Scaling Groups (ASGs): An ASG with one EC2 instance based on the instance_type variable `default to t2.micro`
# ECR: The required ECR repository on AWS to host the docker image
# SECRET-MANAGER: The Module would create 2 secrets manager to store the secrets and parameters required by the container
# KMS: KMS KEY ID used to encrypt the secrets
# ---------------------------------------------------------------------------------------------------------------------

module "ecs-cluster" {
  source = "./modules/ecs-cluster"
  prefix = var.prefix
  common_tags = local.common_tags
  project_name = var.project_name
  private_subnet_ids = var.private_subnet_ids
  public_subnet_ids = var.public_subnet_ids
  vpc_id = var.vpc_id
  ssh_ec2_key_name = var.ssh_ec2_key_name
  instance_type = var.instance_type
  allowed_cidr_blocks = var.allowed_cidr_blocks
  default_sg_id = var.default_sg_id
  aws_profile = var.aws_profile
  min_size = var.min_size
  max_size = var.max_size
  desired_capacity = var.desired_capacity
  s3_logging  = var.s3_logging
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY ECS Resources
# The below module creates
# Task Definition: ECS Task definition used to create the container
# ECS Service: ECS Service and required IAM resources
# EFS: EFS resources and mount points used by the container
# ---------------------------------------------------------------------------------------------------------------------

module "boomi_node" {
  source = "./modules/boomi_node"
  prefix = var.prefix
  common_tags = merge(local.common_tags, map("Module", "Atom Node"))
  ecs_cluster_name = module.ecs-cluster.ecs
  container_name = var.container_name
  desired_count    = var.desired_count
  atom_port             = var.atom_port
  vpc_id                     = var.vpc_id
  private_subnet_ids         = var.private_subnet_ids
  allowed_cidr_blocks        = var.allowed_cidr_blocks
  allowed_security_group_ids = var.allowed_security_group_ids
  kms = module.ecs-cluster.kms
  parameters = module.ecs-cluster.parameters_secret_manager
  repository_url = module.ecs-cluster.repository_url
  image_tag = var.image_tag
  secrets = module.ecs-cluster.secrets_secret_manager
  cloudwatch_container_name = var.cloudwatch_container_name
  cwa_tag = var.cwa_tag
}

