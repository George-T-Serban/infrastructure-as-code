provider "aws" {
  region = "us-east-1"
}

# Create vpc
resource "aws_vpc" "prod-vpc" {
  cidr_block = "10.16.0.0/16"
  tags = {
    Name = "production"
  }
}

# Create private subnet
resource "aws_subnet" "private-subnet" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = "10.16.0.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-subnet"
  }
}

# Create public subnet
resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = "10.16.64.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.prod-vpc.id

  tags = {
    Name = "production"
  }
}

# Assign an elastic ip
resource "aws_eip" "elastic-one" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}

# Create NAT gateway
resource "aws_nat_gateway" "NGW" {
  allocation_id = aws_eip.elastic-one.id
  subnet_id     = aws_subnet.public-subnet.id

  tags = {
    Name = "natGW"
  }

  depends_on = [aws_internet_gateway.igw]
}

# Create public route table
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public"
  }
}

# Create private route table
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NGW.id
  }

  tags = {
    Name = "private"
  }
}

# Associate public subnet with public route table
resource "aws_route_table_association" "associate-public" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-route-table.id

}

# Associate private subnet with private route table
resource "aws_route_table_association" "associate-private" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private-route-table.id

}

# Create security group for the private subnet to allow ssh from the jumpbox 
resource "aws_security_group" "allow_jumpbox_ssh" {
  name        = "allow jumpbox ssh traffic"
  description = "Allow ssh inbound traffic for private subnet"
  vpc_id      = aws_vpc.prod-vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# Create security group for the jumpbox to allow ssh from my ip address only 
resource "aws_security_group" "allow_my_ip_ssh" {
  name        = "allow jumpbox ssh "
  description = "Allow jumpbox ssh inbound traffic from my ip address only "
  vpc_id      = aws_vpc.prod-vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["my IP here/00"] 
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# Get the latest amazon-linux-2 AMI id
data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}

# Create private amazon-linux-2 Ec2 instance 1
resource "aws_instance" "amz-private-1" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = "t2.micro"
  key_name               = "my-key.pem"
  vpc_security_group_ids = [aws_security_group.allow_jumpbox_ssh.id]
  subnet_id              = aws_subnet.private-subnet.id

  tags = {
    Name  = "private-1"
    "Env" = "prod"
  }
}

# Create private amazon-linux-2 Ec2 instance 2
resource "aws_instance" "amz-private-2" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = "t2.micro"
  key_name               = "my-key.pem"
  vpc_security_group_ids = [aws_security_group.allow_jumpbox_ssh.id]
  subnet_id              = aws_subnet.private-subnet.id

  tags = {
    Name  = "private-2"
    "Env" = "dev"
  }
}

# Create jumpbox and run script 
resource "aws_instance" "jumpbox" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = "t2.micro"
  key_name               = "my-key.pem"
  vpc_security_group_ids = [aws_security_group.allow_my_ip_ssh.id]
  subnet_id              = aws_subnet.public-subnet.id
  user_data              = file("/home/george/Projects/jumpbox-ansible/jb-script.sh")

  # Copy ansible.cfg, aws_ec2.yaml, httpd.yaml to jumpbox
  provisioner "file" {
  source      = "/home/george/Projects/jumpbox-ansible/ansible-files"
  destination = "/home/ec2-user"
  }

  connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("/home/george/Projects/jumpbox-ansible/my-key.pem")
      host        = self.public_ip
    }
   

  tags = {
  Name = "ansible-jumpbox"
 }
}

