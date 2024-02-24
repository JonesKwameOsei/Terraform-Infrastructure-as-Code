# Deploying AWS Resources with Infrastructure as Code (IaC)
In our privious [project](https://github.com/JonesKwameOsei/AWSCloud), we demonstrated how infrastrature can be built with scripts on the **command line interface**. In this project, we will utilise **infrastructure as a code (IaC)** to build and deploy infrastructure in the cloud.  Infrastructure as Code (IaC) is a modern approach to managing and provisioning infrastructure through code, rather than manually configuring and maintaining it. IaC treats infrastructure as software, enabling automation, consistency, and version control.

IaC involves defining the infrastructure components, such as servers, networks, and storage, in machine-readable files. These files contain the configuration and deployment instructions for the infrastructure. IaC tools then use these files to automate the provisioning, configuration, and management of the infrastructure.

IaC offers several benefits, including:

1. **Automation**: IaC automates infrastructure provisioning and management tasks, reducing manual effort and human errors.

2. **Consistency**: IaC ensures consistent infrastructure configurations across different environments, promoting standardisation and reducing configuration drift.

3. **Version Control**: IaC allows for version control of infrastructure configurations, enabling easy tracking of changes and facilitating rollbacks if necessary.

4. **Documentation**: IaC serves as documentation for the infrastructure, providing a clear and concise representation of the infrastructure components and their configurations.

5. **Scalability**: IaC simplifies scaling up or down infrastructure resources as needed, enabling rapid provisioning and de-provisioning.

6. **Security**: IaC can enforce security policies and compliance requirements by automating security configurations and monitoring.

7. **Collaboration**: IaC enables collaboration among teams by providing a shared understanding of the infrastructure and its configurations.

8. **Cost Management**: Automated Shutdown is one powerful characteristics of IaC. IaC scripts can include automation for shutting down non-essential resources outside of business hours. This helps in reducing costs by only running resources when needed. Again, it has the ability to shut down all resources when they are not needed anymore ensuring all are shut down wihout leaving any running. This removes the human error to leave an unwanted resource running to incur cost.  

There are many Infrastructure as Code tools but the some of the most popular ones are:<p>
- Terraform
- AWS CloudFormation
- Ansible
- Google Cloud Deployment Manager
- Azure Resource Manager (ARM) Templates

In this project, we will employ **Terraform** to build our resources in the cloud.  Terraform is **an open-source IaC tool allows the definition and provision of infrastructure using a declarative configuration language**. Terraform supports multiple cloud providers and helps in managing infrastructure as code efficiently.

## Set Up
- Create a new user in IAM 
- Create Programmatic Access Keys 
- Creating Connection in VScode with IAM Credentials 
## Creating Resources with Terraform 
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/618c7dec-3b46-42c1-a20d-efb240e2a997)

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
Our **VPC** has been created successfully. Now Let's see the terraform state and  state-backup in our resource files:<p>
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
Our custom vpc, **dev-vpc**, has been created as shown above with the VPC-ID, **vpc-0b0e2732a0982c0bb**. Clearly, this is a newly created VPC as compared to the first one we deleted which had the vpc-ID, **vpc-04552a2b38121e57**. This is the **power** of terraform, infrastructure comes and go as needed.  

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

## Create Internet Gateway
Next, we will give our resources a way to the internet by building an **Internet Gataeway** with the terraform. The internet gateway is a VPC component, that allows communication between vpc and the internet. It supports both IPV4 and IPv6 traffic, hence, it enables resources such as EC2 in the public subnet to connect the internet and vice versa. To provision the gateway, let's run:
```
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mtc-vpc.id

  tags = {
    Name = "dev-igw"
  }
}
```
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/5c3a0249-f520-4371-8657-8d1ca3cdacb9)<p>
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/0ec25170-c3be-4995-8900-240222688c12)<p>

Terraform has successfully mounted the Internet Gateway. Now, we will create a connection between the **IGW** and the **subnet**.

## Create a Route Table
In this task, we will provision a **route table** to route traffic from the subnet to the internet gateway by running this terraform code:
```
resource "aws_route_table" "mtc_public_rtb" {
  vpc_id = aws_vpc.mtc-vpc.id 
  tags = {
    Name = "dev_public_rtb"
  }
}

resource "aws_route" "default_route" {
  route_table_id = aws_route_table.mtc_public_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}
```
This time, we will have two resources to be provision:<p>
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/ace5cd06-e4aa-41b2-a447-7ab921798fda)<p>
This time let's confirm from the resources in the **AWS Explorer** pane in VScode to confirm whether the route table has been successfully been created.<p>
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/888ae217-9aee-404b-9b4f-89b5553b60de)
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/3e15e1cb-0d29-4505-9276-11baf6e403c9)<p>
From the AWS Explorer pane in VScode, it can be observed that all the resources created are found under **Resources** group under **Europe (London)** the default AZ, eu-west-2, where we deploy the infrastcure we are building. Nonetheless, let's confirm from the the AWS Management Console.<p>
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/40ad7d82-b23d-4015-9fa7-604aab025d65)<p>

### Providing Route Table Association
By providing a route table association, we aim at linking the subnet to the route table. The following code creates an association between the subnet and route table. 
```
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.mtc-subnet.id
  route_table_id = aws_route_table.mtc_public_rtb.id
}
```

In the route table page, we will select the **Subnet associations** tab and view the **route table association** we just created.<p>
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/d5d8168b-86d2-42f5-ad37-5f085e78a55f)

## Create Security Groups
Next, we will create a security group and allow outboun and inbound rules. 
```
resource "aws_security_group" "mtc_sg" {
  name        = "dev-sg"
  vpc_id      = aws_vpc.mtc-vpc.id

  ingress {
    from_port   = 0
    to_port     = 0 // we set this port to the maximum port number if you want to allow all ports
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0 // we set this port to the maximum port number if you want to allow all ports
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```
The coode above created the scueirty groups successfully:<p>
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/0879725f-8e52-4bb1-8c03-06f2c42695c5)

## Configuring AMI Datasource
Before we will provision the EC2 instance, we will provide and AMI from which we want deploy. We will do this by utilising **data source**. Data source enables us to query an information from external system or an existing resorces that is added to the configuration in terraform. From then **Amazon Machine Images (AMIs), we will extract the **AMI name** and **owner** details into our datasource code as below:
```
data "aws_ami" "webserver-image" {
    most_recent = true
    owners = ["099720109477"]

    filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"]
    }
```
From the datasource code, the onwer is **099720109477** whiles the AMI name is **ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*.** the * after the **server-** is the release date for the AMI but since we want to get the updated version, we used a wild card instead of an actual date.  When we check the **terraform.tfstate** file, we can observe that the defined instace AMI has been populated but with a different AMI and Owner's details. This is the cases because we set the most recent to true and used the wild card for an updated version of the AMI.<p>
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/fdc54c15-e74d-4d2a-b9c3-7290a51d26e9)<p>

### Create Key Pair
Next, we will create a key pair then create a terraform resources that uses the keay pair.<p>
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/264a3b73-dd4c-477b-9a0b-359e9edefa65)<p>

We will now proceed to create the key pair with terraform:<p>
```
resource "aws_key_pair" "mtc_auth" {
  key_name = "mtckey"
  public_key = file("~/.ssh/mtckey.pub")
}
```
From the key pair page in the AWS Management console, the resource **mtckey** has been created:<p>
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/264ec79f-216b-4d61-b927-6a714b398356)<p>

## Provisioning EC2 Instance
We will provision the EC2 instance with the following ci=onfiguration:
```
resource "aws_instance" "Dev_node" {
  instance_type = "t2.micro"
  ami = data.aws_ami.webserver_image.id
  key_name = aws_key_pair.mtc_auth.id
  vpc_security_group_ids = ["aws_security_group.mtc_id"]
  subnet_id = aws_subnet.mtc-subnet.id

  root_block_device {
    volume_size =  10
  }

  tags = {
    Name = "dev.node"
  }
}
```
For our EC2 and all the the other resources, we will employ **userdata** to boostrap and install a docker engine for our development. 
**userdata**:
```
#!/bin/bash

# Update package lists and install prerequisites
sudo apt-get update -y && \
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common && \

-- Adding Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \

-- Adding Docker repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \

-- Update package lists again
sudo apt-get update -y && \

-- Installing Docker packages
sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io && \

-- Adding current user to the docker group
sudo usermod -aG docker "$(whoami)"
```
finally, our insatnce will programmatically looks like this:
```
resource "aws_instance" "Dev_node" {
  instance_type = "t2.micro"
  ami = data.aws_ami.webserver_image.id
  key_name = aws_key_pair.mtc_auth.id
  vpc_security_group_ids = ["aws_security_group.mtc_id"]
  subnet_id = aws_subnet.mtc-subnet.id
  user_data = file("userdata.tpl")

  root_block_device {
    volume_size =  10
  }

  tags = {
    Name = "dev.node"
  } 
}
```
Let's provision our instnace with:
```
terraform plan

tearraform apply
```

Our instance has been provisioned with all the predifined resources as below:<p>
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/667227c2-b144-4141-b554-018a3ad80371)<p>

Now, let's try to SSH into our instance. As explained earlier, we can get all the information of our infrastructure by runing:
```
terraform show
```
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/ec871474-99c4-4b00-b4bc-ceea1560a166)

Succesffuly ssh into the instance:<p>
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/7236daa0-df2b-4421-9a10-b67f5ad98a07)<p>

Let's confirm if a docker contanier was also installed:<p>
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/78dc5a92-90e1-4a09-a0f7-705ea5d18076)<p>
The conatainer was successfully installed. 

## Setting Configuration Files to Connect VScode to EC2 Instance
We can configure files to connect to our instance from VScode. Conventionally, we would just use the **public IP address** from our insyance with the key pair downloaded when creating an instance to do the ssh connecting. Here, the aim to to ssh our instance with a **Remote SSH** from VScode. First, we will create a **template files**. 

In VScode, we will create new files (in the directory with the main.tf) and add the configuration. 

Based on the operating system, **Windows** users can do the following configuration (windows-ssh-config.tpl):
```
add-content -path C:/Users/KWAME/.ssh/config

Host ${hostname}
    Hostname ${hostname}
    User ${user}
    Identifyfile ${Identifyfile}
```

The following configuretion is best for Unix/Linux systems (linux-ssh-config.tpl):
```
cat << EOF >> ~/.ssh/config

Host ${hostname}
    Hostname ${hostname}
    User ${user}
    Identifyfile ${Identifyfile}
EOF
``` 

Next, we will utilise a provisioner to do the configuration on our local terminal to enable SSH into EC2 instance.<p>
**Note**: Terraform state will not manage or record a provisioner's success or failure unlike other resources. Terraform stresses from the provisioner documentation that it should be the last results. In view of this, a provisioner should not be sonething developers should use for every deploment. Check the [documentation](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax) for more.<p>

We will embed the provisioner utility into our instance and replace or reploy it. 
```
provisioner "local-exec" {
    command = templatefile("linux-ssh-config.tpl", {
      hostname = self.public_ip,
      user = "ubuntu",
      identityfy = "~/.ssh.mtckey"
    })
    interpreter = ["bash", "-c"]
  }
```
Terraform does not automatically identify the provisioner utility by running **terraform plan**. To effect the 
the chnages, we will run terraform apply --replace <name of the instance>:
```
terraform apply -replace aws_instance.Dev_Node
```
This has alert terraform of the new changes:<p>
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/7e33dcdd-2ff1-4fd5-9698-3840af960902)<p>
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/4a09a421-65e3-4df8-905d-b827376a6052)<p>

Terraform has successfully destroyed the instance deployed earlier and has replcaed it with a new instance:<p>
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/4f01a128-c387-491e-8880-b4d075c49e7e)<p>
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/f8a71f5f-c9eb-4732-bee4-99b2fc79a0a9)<p>

Evidently, the newly provisioned instance has **Public IP Address** **18.171.241.140** as compared to the earlier one we used to SSH with the IP address **18.135.15.162**. This demonstrates that **Terraform** has replaced our resouces.<p>

Now, we will investigate whether our SSH config file was also provisioned together with the resources. Run the command below to see the config file (this project utilised the linux config file - with Windows but Gitbash in VScode works well as linux ecosystem):
```
cat ~/.ssh/config
```
The results return is below:<p>
![image](https://github.com/JonesKwameOsei/Terraform/assets/81886509/e191f4b7-3d75-4383-825a-c0dd047109e6)
```
Host 18.171.241.140
    Hostname 18.171.241.140
    User ubuntu
    Identifyfile ~/.ssh.mtckey
```
From the results, we can observe that the provisioner did exactly what we asked for. It added the IP address **18.171.241.140**, the **hostname**, user as **ubuntu** and our identifyfiler as **~/.ssh/config**. 

## Conclusion
In this project, we successfully provisioned resources with an Infrastructure as Code, terraform, to be specific in the AWS Cloud. We defined our resources with IaC codes and terraform provisioned all the resources for us. This is not the only Capability of Terraform, we could explore more and even provision resource locally. 

## Acknowledgement
I would like to express my gratitude to my mentor, **Jay Kwashe**, whose inspiration guided me through the successful completion of my Terraform project. Thank you for your invaluable support and guidance.
















