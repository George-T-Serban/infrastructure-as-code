# Ansible dynamic inventory
  Basic inventory setup:
* Install AWS boto3 library: `sudo pip3 install boto3`.
* Create the dynamic inventory file `aws_ec2.yaml (aws_ec2.yaml extension is mandatory)` in project's directory.
* Edit ansible.cfg in project's folder:          
	 ```
	 [inventory]   
	 enable_plugins = aws_ec2 
	 ```
* Run `ansible-inventory --list` to get a list of all EC2 instances with all parameters.
* Run `ansible all -m ping` to test.
