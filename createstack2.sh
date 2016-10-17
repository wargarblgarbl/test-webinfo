#!/usr/bin/env bash
if [ ! -f ec2.py ]; then
    curl -s https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.py > ec2.py
    chmod +x ec2.py
fi
if [ ! -d keys ]; then
mkdir keys
fi
#Dynamic Inventory exports
export ANSIBLE_HOSTS=./ec2.py
export ANSIBLE_HOST_KEY_CHECKING=false
export EC2_INI_PATH=./ec2.ini

#Create Keypair for us to use
#In reality, we probably need a better way of securing this key.
#Alternatively, use a keystore, or already have the key generated.
#For the purposes of this exercise, I included this stub code to
#generate a quick RSA key for the ansible playbooks to use.

echo "" | ssh-keygen -t rsa -f ./keys/micro

#Run the playbook
ansible-playbook ./playbooks/micro2.yml
#Refresh our inventory cache
./ec2.py --refresh-cache
ansible-playbook playbooks/nginx_deploy.yml --private-key ./keys/micro
#run tests
env bash ./teststack.sh
