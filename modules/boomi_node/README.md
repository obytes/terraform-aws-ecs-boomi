## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allowed\_cidr\_blocks | A list of strings contains the CIDR blocks e.g. 10.10.10.0/26 which allowed to access the ALB | `list(string)` | n/a | yes |
| allowed\_security\_group\_ids | A list of security group IDs to have access to the container | `list(string)` | `[]` | no |
| atom\_port | The port number for the Atom which is defaulted to 9090 | `number` | n/a | yes |
| cloudwatch\_container\_name | CloudWatch Agent container name | `string` | n/a | yes |
| common\_tags | A map of tags to tag the resources | `map(string)` | n/a | yes |
| container\_name | The Container Name | `string` | n/a | yes |
| cwa\_tag | Docker image tag for the CloudWatch Agent | `string` | n/a | yes |
| desired\_count | The number of instances of the task definition to place and keep running. | `number` | n/a | yes |
| ecs\_cluster\_name | A map of strings for the ECS cluster, valid keys are name and ARN | `map(string)` | n/a | yes |
| image\_tag | The image tag used by the ECS Task definition to create Atom Container | `string` | `"latest"` | no |
| kms | A map of string for the KMS, valid keys are id and ARN | `map(string)` | n/a | yes |
| parameters | A map of AWS Secret Manager parameters, valid values are name, id and ARN | `map(string)` | n/a | yes |
| prefix | A prefix string used to name the resources | `string` | n/a | yes |
| private\_subnet\_ids | A list of strings contains the IDs of the private subnets in the vpc | `list(string)` | n/a | yes |
| repository\_url | ECR repository URL | `string` | n/a | yes |
| secrets | A map of AWS Secret Manager secrets, valid values are name, id and ARN | `map(string)` | n/a | yes |
| task\_definition\_cpu | CPU for the task definition | `number` | `256` | no |
| task\_definition\_memory | Memory for the task definition | `number` | `512` | no |
| vpc\_id | VPC ID, example vpc-1122334455 | `string` | n/a | yes |


## Outputs

| Name | Description |
|------|-------------|
| aws\_efs\_access\_point | n/a |
| file\_system\_id | n/a |
| security\_group\_id | n/a |
| service\_name | n/a |

