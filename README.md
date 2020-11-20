## Usage 
```hcl
module "boomi_node" {
  source = "git::https://github.com/obytes/boomi-aws-ecs.git?ref=tags/v0.0.2"
  env = var.env
  project_name = var.project_name
  aws_profile = var.aws_profile
  region = var.region
  vpc_id = var.vpc_id
  private_subnet_ids = var.private_subnet_ids
  public_subnet_ids = var.public_subnet_ids
  default_sg_id = var.default_sg_id
  allowed_cidr_blocks = var.allowed_cidr_blocks
  ssh_ec2_key_name = var.ssh_ec2_key_name
  instance_type = var.instance_type
  min_size = var.min_size
  max_size = var.max_size
  desired_capacity = var.desired_capacity
  desired_count = var.desired_count
  container_name = var.container_name
  atom_port = var.atom_port
  task_definition_cpu = var.task_definition_cpu
  task_definition_memory = var.task_definition_memory
  allowed_security_group_ids = var.allowed_security_group_ids
}
```
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| aws | = 3.3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | = 3.3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allowed\_cidr\_blocks | A list of strings contains the CIDR blocks e.g. 10.10.10.0/26 which allowed to access the ALB | `list(string)` | n/a | yes |
| allowed\_security\_group\_ids | A list of security group IDs to have access to the container | `list(string)` | `[]` | no |
| atom\_port | The port number for the Atom which is defaulted to 9090 | `number` | `9090` | no |
| aws\_profile | The AWS Profile name with the required permissions stored in ~/.aws/credentials used by Terraform to create the resources | `string` | n/a | yes |
| container\_name | The Container Name | `string` | `"atom_node"` | no |
| default\_sg\_id | Default SG ID for the VPC | `string` | n/a | yes |
| desired\_capacity | The number of Amazon EC2 instances that should be running in the group | `number` | n/a | yes |
| desired\_count | The number of instances of the task definition to place and keep running. | `number` | n/a | yes |
| env | Environment Name such as qa,prd,adm. Its recommended to keep it 3 chars long max as this will be used to structure the ID/Name of resources | `string` | `"prd"` | no |
| instance\_type | Instance Type, e.g. t2.micro | `string` | n/a | yes |
| max\_size | The maximum size of the auto scale group | `number` | n/a | yes |
| min\_size | The minimum size of the auto scale group | `number` | n/a | yes |
| private\_subnet\_ids | A list of strings contains the IDs of the private subnets in the vpc | `list(string)` | n/a | yes |
| project\_name | Project Name . Its recommended to keep it 3 chars long max as this will be used to structure the ID/Name of resources | `string` | `"boomi"` | no |
| public\_subnet\_ids | A list of strings contains the IDs of the public subnets in the vpc | `list(string)` | n/a | yes |
| region | The Region name, This will be edited to removed the hyphens such as useast1 and used by the ID/Name of resources | `string` | `"us-east-1"` | no |
| ssh\_ec2\_key\_name | the name of the pair key to access the ec2 | `string` | n/a | yes |
| task\_definition\_cpu | CPU for the task definition | `number` | `256` | no |
| task\_definition\_memory | Memory for the task definition | `number` | `512` | no |
| vpc\_id | VPC ID, example vpc-1122334455 | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| aws\_efs\_access\_point | n/a |
| ecs | n/a |
| file\_system\_id | n/a |
| kms | n/a |
| parameters\_secret\_manager | n/a |
| repository\_url | n/a |
| s3\_logging | n/a |
| secrets\_secret\_manager | n/a |
| security\_group\_id | n/a |
| service\_name | n/a |

