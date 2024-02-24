resource "aws_vpc" "mtc-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev-vpc"
  }
}

resource "aws_subnet" "mtc-subnet" {
  vpc_id                  = aws_vpc.mtc-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2a"

  tags = {
    Name = "dev-public"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mtc-vpc.id

  tags = {
    Name = "dev-igw"
  }
}

resource "aws_route_table" "mtc_public_rtb" {
  vpc_id = aws_vpc.mtc-vpc.id
  tags = {
    Name = "dev_public_rtb"
  }
}

#create a default route table
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.mtc_public_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.mtc-subnet.id
  route_table_id = aws_route_table.mtc_public_rtb.id
}

resource "aws_security_group" "mtc_sg" {
  name        = "dev-sg"
  vpc_id      = aws_vpc.mtc-vpc.id

  ingress {
    from_port   = 0
    to_port     = 0 
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0 
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "mtc_auth" {
  key_name = "mtckey"
  public_key = file("~/.ssh/mtckey.pub")
}

resource "aws_instance" "Dev_Node" {
  instance_type = "t2.micro"
  ami = data.aws_ami.webserver_image.id
  key_name = aws_key_pair.mtc_auth.id
  vpc_security_group_ids = [aws_security_group.mtc_sg.id]
  subnet_id = aws_subnet.mtc-subnet.id
  user_data = file("userdata.tpl")

  root_block_device {
    volume_size =  10
  }

  tags = {
    Name = "dev.node"
  } 

  provisioner "local-exec" {
  command = templatefile("window-ssh-config.tpl", {
    hostname = self.public_ip,
    user = "ubuntu",
    Identityfile = "~/.ssh.mtckey"
  })
  interpreter = ["Powershell", "-Command"]
}
}

