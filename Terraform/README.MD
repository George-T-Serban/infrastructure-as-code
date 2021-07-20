# AWS-Systems-Manager Template
Creates six EC2 instances and registers with AWS Systems Manager to enable the ssm-agent for more secure connectivity and patching. 

* vars.tf - Define variables.

* terraform.tfvars - Assign values to variables defined in vars.tf.

* main.tf - main set of configuration.

* rh_ssmagent.sh - Script to install and register the ssm-agent on Rhel8 instances.

* ub_ssmagent.sh - Script to register the ssm-agent on Ubuntu 20.04 instances. Ubuntu AMI's (18.04 & 20.04) have the ssm-agent installed by default.

* amz_ssmagent.sh - Script to register the ssm-agent on Amazon Linux 2 instances. Amazon Linux 2 AMIs have the ssm-agent installed by default.
