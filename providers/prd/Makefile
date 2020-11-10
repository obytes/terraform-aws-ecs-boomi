init:
		@terraform init

plan:
	@terraform plan

apply:
	@terraform apply

output:
	@terraform output

refresh:
	@terraform refresh

pull_tfvars:
	@aws s3 --profile obytes cp s3://terraform-obytes/aws/prd/us-east-1/terraform.tfvars .

push_tfvars:
	@aws s3 --profile obytes cp terraform.tfvars s3://terraform-obytes/aws/prd/us-east-1/terraform.tfvars
