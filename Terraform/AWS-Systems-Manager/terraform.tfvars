# Assign values to variables defined in vars.tf
instance_type = "t2.micro"

ami_id = {
  "rhel8"        = "ami-0b0af3577fe5e3532"
  "ubuntu_20.04" = "ami-09e67e426f25ce0d7"
  "amz_linux2"   = "ami-0dc2d3e4c0f9ebd18"
}

