# Ansible dynamic inventory
  Basic inventory setup:
	* Install AWS boto3 library: sudo pip3 install boto3.
	* Create the dynamic inventory file aws_ec2.yaml (name is mandatory) in project's directory.
	* Edit /etc/ansible/ansible.cfg: 
		[inventory]
		enable_plugins = aws_ec2 
	* Run ansible-inventory --list to get a list of all EC2 instances with all parameters.
	* Run ansible all -m ping to test.
