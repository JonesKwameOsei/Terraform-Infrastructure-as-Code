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

 ## Deploying a Virtual Private Network (VPC)
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

Since we will be needing this VPC to build other infrastructures, we will create the vpc again by running the **apply** command:<p>
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/def4870f-d5fc-4a01-a932-0a2b354f6822)<p>
Command executed without error. We will confirm from the VPC pane in the AWS management console.<p>
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/da4815d9-ed3a-46f5-9441-791589bcd7a4)<p>
Our custom vpc, **dev-vpc**, has been created as shown above with the VPC-ID, **vpc-0b0e2732a0982c0bb**. Clearly, this is a newly created VPC as compared to the first one we deleted which had the vpc-ID, vpc-04552a2b38121e57**. This is the *power** of terraform, infrastructure comes and go as needed.  

## Deploying a Subnet and Referencing Other Resources
Next, we will deploy a subnet to which we will bdeploy our Elastic Compute Cloud (EC2). Let's add another resource:
```
resource "aws_subnet" "mtc-subnet" {
    vpc_id = aws_vpc.mtc-vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = "eu-west-2a"

    tags = {
    Name = "dev-public"
  }
}
```
Next, we will run the plan command to review our infrastructure, then apply the configurations to create the **public subnet** in *AZ eu-west-2*.<p>

![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/5d66d554-07db-4c08-8729-da9ec82d72db)<p>
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/a7613aa6-1978-4fd6-b59c-6d9c159a3ab1)<p>
Having ran the **terraform apply** command, we have created a public subnet, **dev-public**, with the cidr_block *10.0.1.0/24* in a speicified region, *eu-west-2a* as seen below:<p>
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/e44bb65f-09a4-4c52-9b84-72d3d83fcf7f)<p>







