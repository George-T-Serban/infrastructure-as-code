#!/bin/bash 
    # ssm-agent installed by default on Ubuntu 20.04.
    # Register ssm-agent with Systems Manager
    sudo /snap/amazon-ssm-agent/current/amazon-ssm-agent -register -code "my_code" -id "my_id" -region "us-east-1" 
    sudo systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service