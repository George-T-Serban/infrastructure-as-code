#!/bin/bash
    hostnamectl set-hostname ansible-jumpbox
    pip3 install --user ansible
    pip3 install --user boto3 
    cd /home/ec2-user/ansible-files
    sudo /root/.local/bin/ansible-playbook httpd.yaml > /home/ec2-user/ansible-files/results-output.file
