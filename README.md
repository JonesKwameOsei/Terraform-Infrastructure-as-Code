# Terraform
## Deploying infrastructure with Terraform
## Create a new user in IAM 
### Create Access Keys 
## Creating Connection in VScode with IAM Credentials 
## Set up
1. Create a **Provider**.<p>
```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      #version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                   = "eu-west-2"
  shared_config_files      = ["~/.aws/conf"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "myterra-vscode"
}
```

2. Create a **VPC**
```
resource "aws_vpc" "mtc-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "dev-vpc"
  }
}
```
To privision this resource, we will run:
```
terraform plan
```
and 
```
terrafoem apply
```
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/2ebb11d4-526a-4d09-9482-912bd991e2c9)<p>

