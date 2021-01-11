## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allowed\_cidr\_blocks | A list of strings contains the CIDR blocks e.g. 10.10.10.0/26 which allowed to ssh to EC2 node | `list(string)` | n/a | yes |
| aws\_profile | The AWS Profile name with the required permissions stored in ~/.aws/credentials used by Terraform to create the resources | `string` | n/a | yes |
| common\_tags | a map of shared tags to be used by the modules' resources | `map(string)` | n/a | yes |
| default\_sg\_id | Default SG ID for the VPC | `string` | n/a | yes |
| desired\_capacity | The number of Amazon EC2 instances that should be running in the group | `number` | n/a | yes |
| instance\_type | Instance Type, e.g. t2.micro | `string` | n/a | yes |
| max\_size | The maximum size of the auto scale group | `number` | n/a | yes |
| min\_size | The minimum size of the auto scale group | `number` | n/a | yes |
| prefix | A prefix string will be used to structure the ID/Name of resource | `string` | n/a | yes |
| private\_subnet\_ids | A list of strings contains the IDs of the private subnets in the vpc | `list(string)` | n/a | yes |
| project\_name | Project Name . Its recommended to keep it 3 chars long max as this will be used to structure the ID/Name of resources | `string` | `"boomi"` | no |
| public\_subnet\_ids | A list of strings contains the IDs of the public subnets in the vpc | `list(string)` | n/a | yes |
| s3\_logging | AWS S3 Bucket details used by the modules, required keys are bucket\_name and bucket\_arn | `map(string)` | n/a | yes |
| ssh\_ec2\_key\_name | the name of the pair key to access the ec2 | `string` | n/a | yes |
| vpc\_id | VPC ID, example vpc-1122334455 | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ecs | ecs |
| kms | n/a |
| parameters\_secret\_manager | n/a |
| repository\_url | n/a |
| s3\_logging | n/a |
| secrets\_secret\_manager | n/a |

