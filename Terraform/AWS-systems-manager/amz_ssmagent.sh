#!/bin/bash 
    # ssm-agent installed by default on Amazonlinux2.
    # Register ssm-agent with Systems Manager
    sudo systemctl stop amazon-ssm-agent
    sudo amazon-ssm-agent -register -code "my_code" -id "my_id" -region "us-east-1"    sudo systemctl enable amazon-ssm-agent
    sudo systemctl start amazon-ssm-agent