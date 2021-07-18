# AWS-Systems-Manager Template
Creates six EC2 instances and registers with AWS Systems Manager to enable the ssm-agent for more secure connectivity and patching. 

vars.tf - Define variables.

terraform.tfvars - Assign values to variables defined in vars.tf.

main.tf - main set of configuration.

rh_ssmagent.sh - Script to install and register the ssm-agent with Systems Manager.

ub_ssmagent.sh - Script to register the ssm-agent with Systems Manager. The ssm-agent is installed bay default on Ubuntu 20.04 AMIs.

amz_ssmagent.sh - Script to register the ssm-agent with Systems Manager. The ssm-agent is installed bay default on Amazon Linux 2.
