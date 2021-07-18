#!/bin/bash 
   # Install ssm-agent on Rhel8 instances and register with Systems Manager
   sudo yum install -y https://s3.us-east-1.amazonaws.com/amazon-ssm-us-east-1/latest/linux_amd64/amazon-ssm-agent.rpm
   sudo amazon-ssm-agent -register -code "my_code" -id "my_id" -region "us-east-1"
   sudo systemctl enable amazon-ssm-agent
   sudo systemctl start amazon-ssm-agent