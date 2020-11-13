# boomi_aws_ecs

Terraform module setting up and provisioning Boomi dockerized infrastructure

Find instructions to deploy this on: https://www.obytes.com/blog/sending-notifications-to-slack-using-aws-chatbot

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
|parameters_secret_manager | map(string) | The ARN and the id of the applied parameters AWS secrets manager|
|repository_url | string | The repository URL where the task definition will pull the Docker image.|
|S3_logging| map(string) | A map for the S3 logging bucket created by the common which includes the ID,ARN and Bucket Name|

<!--- END_TF_DOCS --->
