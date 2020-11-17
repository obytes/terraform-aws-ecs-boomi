# boomi_aws_ecs

Terraform module setting up and provisioning Boomi dockerized infrastructure

### Setup
 - Clone the Repo
```bash
git clone https://github.com/obytes/boomi-aws-ecs.git
```
 - Create terraform.tfvars providers/prd
```bash
cd boomi-aws-ecs/providers/prd/
touch terraform.tfvars
```
 - Populate the variables values required, please refer below to the **Inputs** section, e.g.
```bash
# CD to the PRD provider dir
cd boomi-aws-ecs/providers/prd
# Populate the required variables, please don't forget to escape the double quotes
echo vpc_id = \"vpc-112233445566\" >> terraform.tfvars
```

 - Build the Atom docker image
 ```bash
# CD to repo directory
cd boomi-aws-ecs 
# Build the image
#docker build -t <image_name>:<tag> .
docker build -t boomi:latest
```

 - Run terraform plan/apply for the common module to set up all the required resources in order to to run the Boomi ecs container
 ```bash
# CD to the PRD provider dir
cd boomi-aws-ecs/providers/prd/
terraform init
terraform plan --target module.common
terraform apply --target module.common
 ```

 - Push the docker image to ecr created by applying the `terraform apply --target module.common`
    - Note: in our [task-definition](https://github.com/obytes/boomi-aws-ecs/blob/95eae30eb9b4a584f9b7ffbddcfb2d5b753a625a/modules/boomi/molecule/ecs_task_definition.tf#L18) we are referring to a dynamic tag based on the `var.env` but this can be changed if you would like.
 ```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com

docker tag boomi:latest <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/prd-boomi-useast1:<tag>

docker push <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/prd-boomi-useast1:<tag>
 ```

 - Adding the required secrets **INSTALL_TOKEN** and **BOOMI_ACCOUNTID** to `prd-boomi-useast1-secs` secrets manager on AWS console using the key/value pair.
 
 - Run terraform plan/apply for the boomi module to create the boomi ecs container and map it to your boomi account.
 ```bash
# CD to the PRD provider dir
cd boomi-aws-ecs/providers/prd/
terraform plan --target module.boomi
terraform apply --target module.boomi
 ```

Find instructions to setup this on: [provisioning-boomi-on-aws-ecs](https://obytes.com/blog/provisioning-boomi-on-aws-ecs)

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
