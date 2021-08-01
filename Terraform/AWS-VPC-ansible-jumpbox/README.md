Deploys a custom VPC and enables outgoing internet access for private instances in order to be
provisioned using an Ansible jumpbox.
-------------

Resources created:
* Custom VPC.
* Private subnet. 
* Public subnet.
* Internet Gateway - attached to the VPC, provides internet access.
* Elastic IP address - attached to the NAT Gateway.
* Public NAT Gateway - attached to the public subnet, routes traffic to the Internet Gateway.
* Public route table - attached to the Internet Gateway.
* Private route table - attached to the NAT Gateway.
* Route tables associations - associate the public subnet with the public route table and the private subnet with the private route table.
* Security group for private instances: allow SSH only.
* Security group for the public instance (jumpbox): allow SSH from MY_IP_ADDRESS only.
* Two amazon-linux-2 Ec2 instances in the private subnet with tags "Env = prod", "Env = dev".
* One amazon-linux-2 Ec2 instance (jumpbox) in the public subnet with tag "Name = ansible-jumpbox".

Copies Ansible project files to the jumpbox instance:
* `ansible.cfg` - main Ansible configuration file
* `aws_ec2.yaml` - dynamic inventory: install apache on "prod" instance only
* `httpd.yaml` - playbook to install apache 

Executes script to install Ansible on jumpbox and run playbook:
* `jb-script.sh`
