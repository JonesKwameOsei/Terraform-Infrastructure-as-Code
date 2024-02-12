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
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/fb717746-378d-4fef-9b7d-97ec6b3b2f68)<p>
Our **VPC** has been created successfully. Now Let's see the terraform state and  state-backup in our resource files:
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/4f1bc728-537b-4cf9-b9ce-f09f831f4a65)
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/3d23c998-0880-47f8-92f8-5c2eba4da56f)<p>

Also, let's compare this to the resource in the AWS Explorer in VScode:<p>
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/00ebb30a-07f4-4036-8061-97d19fb8b5f5)<p>
Next, we will view our state list by running the code: 
```
terraform state list
```
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/c99dfd3c-6570-405f-9fbc-ab6d0d85b06d)<p>
The code above returned one list, **aws_vpc.mtc-vpc**, the vpc we created. If we want to return all the componenets of the resource (VPC) created, We must run:
```
terraform state show aws_vpc.mtc-vpc
```
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/8b448071-2e6b-47c2-9a72-36c5b223656d)<p>
If there are numerous resources, we can list all simultanously with by running:
```
terraform show
```
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/207804d0-5ab2-4c99-9018-74c7ded80d71)<p>
This lists every resources we have provisioned. We only have one resource, hence, only one was listed. 

## Unprovisioning Resources
Terraform comes with the ability build and tear down infrastructure. Here, we will delete the VPC created with the **destroy** commanad by running:
```
terraform destroy -auto-approve
```
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/9ee3aed4-047a-4e00-bd8d-5b4e5b95435a)
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/ae61405a-add5-49ba-a496-0445d93475aa)<p>
Lets refresh the VPC panel on AWS to confirm if our **custom VPC** has been deleted.<p>
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/4938792c-1a7d-482d-9382-486f1d2e1bed)<p>
Successfully, **Terraform** has teared down the vpc. 





