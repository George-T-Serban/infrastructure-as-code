provider "aws" {
  region     = "us-east-1"
  access_key = "my_access_key"
  secret_key = "my_secret_key"
}

# Create Security Group to allow ssh
resource "aws_security_group" "ssh-sg" {
  name        = "ssh-sg"
  description = "Allow ssh"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Deploy 2 RHEL8 instances
resource "aws_instance" "rhel8_ec2" {
  count                  = 2
  ami                    = var.ami_id["rhel8"]
  instance_type          = var.instance_type
  key_name               = "my_key_name"
  vpc_security_group_ids = [aws_security_group.ssh-sg.id]
  iam_instance_profile   = "my-role"
  user_data              = file("rh_ssmagent.sh")
  tags = {
    Name          = "Rhel8-server-${count.index + 1}"
    "Patch Group" = "Production"
  }

}
# Deploy 2 Ubuntu 20.04 instances
resource "aws_instance" "ubuntu20_04_ec2" {
  count                  = 2
  ami                    = var.ami_id["ubuntu_20.04"]
  instance_type          = var.instance_type
  key_name               = "my_key_name"
  vpc_security_group_ids = [aws_security_group.ssh-sg.id]
  iam_instance_profile   = "my-role"
  user_data              = file("ub_ssmagent.sh")
  tags = {
    Name          = "Ubuntu20.04-server-${count.index + 1}"
    "Patch Group" = "Dev"
  }

}
# Deploy 2 Amazon Linux 2 instances"
resource "aws_instance" "Amazon-Linux2_ec2" {
  count                  = 2
  ami                    = var.ami_id["amz_linux2"]
  instance_type          = var.instance_type
  key_name               = "my_key_name"
  vpc_security_group_ids = [aws_security_group.ssh-sg.id]
  iam_instance_profile   = "my-role"
  user_data              = file("amz_ssmagent.sh")
  tags = {
    Name          = "Amazon-Linux-server-${count.index + 1}"
    "Patch Group" = "General"
  }

}
