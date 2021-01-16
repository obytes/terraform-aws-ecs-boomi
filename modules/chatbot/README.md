## Summary

A module to create AWS Chatbot resources with SNS Topic and Integrate it with Slack Workspace/Channel

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| common\_tags | A map of tags to tag the resources | `map(string)` | n/a | yes |
| prefix | A prefix string used to name the resources | `string` | n/a | yes |
| slack\_channel\_id | The Slack channel ID where AWS Chatbot would post the messages | `string` | n/a | yes |
| slack\_workspace\_id | The Slack workspace/organization ID | `string` | n/a | yes |
| sns\_topic\_arns | A list of SNS topic which AWS Chatbot listens on | `list(string)` | n/a | yes |

## Outputs

No output.
