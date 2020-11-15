# boomi_aws_ecs

Terraform module setting up and provisioning Boomi dockerized infrastructure

### Setup
 - Create terraform.tfvars to define the required variables mentioned below under providers/prd
 - Run terraform plan/apply for the common module to set up all the required resources in order to to run the Boomi ecs container
 - Run terraform plan/apply for the boomi module to create the boomi ecs container and map it to your boomi account.

Find instructions to setup this on: https://www.obytes.com/blog/sending-notifications-to-slack-using-aws-chatbot

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | = 0.13 |

## Providers

| Name | Version |
|------|---------|
| aws | 3.3.0 |
| local | n/a |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| env | The name of the environment such as `prd,stg,dev` | string | prd | yes |
| project\_name | The name of the project e.g `boomi` | string | boomi | yes |
| region | The name of aws region | string | us-east-1 | yes |
| aws\_profile | The name of the aws_profile which will be used by the aws terraform provider located in `~/.aws/credentials` | `any` | n/a | yes |
| vpc\_id | AWS VPC ID  | `any` | n/a | yes |
| private\_subnet\_ids | The Private Subnet IDs to be used to create the EC2 resources | `list(string)` | n/a | yes |
| public\_subnet\_ids | The Public Subnet IDs  | `list(string)` | n/a | yes |
| allowed_cidr_blocks | A list of allowed cidr blocks which will be used to connect to EC2 nodes  | `list(string)` | n/a | yes |
| default\_sg\_id | The default SG id which which will be allowed to connect to EC2 private resources  | string | n\a | yes |
| ssh\_ec2\_key\_name | the name of the ssh_key used to create the ec2 resources  | string | | n/a | yes |
| instance\_type | EC2 instance Type  | string | `t2.micro` | yes |


## Outputs

| Name | Type | Description |
|------|------|-------------|
| ecs | map(string) |ECS Output form the common module which have the `arn` and `name`.|
| kms_id | string | The KMS Id which will be used by the ECS Container Task definition. |
|parameters_secret_manager | map(string) | The ARN and the id of the applied parameters AWS secret manager|
|secrets_secret_manager | map(string) | The ARN and the id of the applied secrets e.g. `BOOMI_ACCOUNTID` and `INSTALL_TOKEN` AWS secret manager|
|repository_url | string | The repository URL where the task definition will pull the Docker image.|
|security_group_id | string | The SG id for the Boomi Atom container.|
|S3_logging | map(string) | A map for the S3 logging bucket created by the common which includes the ID,ARN and Bucket Name|
|service_name | string | The ECS service name for Boomi Atom |
|file_system_id | string | EFS filesystem ID | 
|aws_efs_access_point | string | File System Access Point ID


<!--- END_TF_DOCS --->
