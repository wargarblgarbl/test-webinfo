# Ansible/CloudFormation Setup/Testing/Teardown scripts

###Dependencies
- Python - everything has been tested with python 2.7
- Ansible - Installation instructions: http://docs.ansible.com/ansible/intro_installation.html
- awscli - Installation instructions:  http://docs.aws.amazon.com/cli/latest/userguide/installing.html
- bash - the shell scripting portions of these scripts are written in bash, and possibly contain bashisms.
- dynamic ansible inventory script for aws - provided if by the teststack.sh script, the ini file is included. 

###Instructions
- To spin up and run automated tests on the stack
* Clone repository
* execute `./createstack.sh`
- To run automated tests
* execute `./teststack.sh`
- To tear down the stack
* execute `./deletestack.sh`
