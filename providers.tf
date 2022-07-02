# NOTE: Terraform runs all the .tf files in same directory as one
# To run terraform (IPAD)
# $ terraform init
# $ terraform plan
# $ terraform apply
# $ terraform apply -auto-approve
# $ terraform destroy
# $ terraform destroy -auto-approve

# to format the file
# $ terraform fmt

# to view state of our resources
# $ terraform state list
# $ terraform state show type_the_resource_name
#  e.g.
# $ terraform state show aws_vpc.mtc_vpc
# to see the entire state of all resources
# $ terraform show 

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Shared Credentials
provider "aws" {
  region                   = "us-west-2"
  shared_credentials_file = "~/.aws/credentials"
  profile                  = "vscode"
}