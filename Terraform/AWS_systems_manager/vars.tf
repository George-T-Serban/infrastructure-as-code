# Define variables
variable "ami_id" {
  type        = map(any)
  description = "AWS AMI id"
}

variable "instance_type" {
  type        = string
  description = "AWS instance type"
}

