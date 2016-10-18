#!/usr/bin/env bash


#Set us up to work
if [ ! -d keys ]; then
    mkdir keys
fi
if [ ! -f ./dyninventory/ec2.py ]; then
    curl -s https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.py > ./dyninventory/ec2.py
    chmod +x ec2.py
fi



#Dynamic Inventory exports
export ANSIBLE_HOSTS=`pwd`/dyninventory/ec2.py
export EC2_INI_PATH=`pwd`/dyninventory/ec2.ini
export ANSIBLE_HOST_KEY_CHECKING=false

#Create Keypair for us to use
#In reality, we probably need a better way of securing this key.
#Alternatively, use a keystore, or already have the key generated.
#For the purposes of this exercise, I included this stub code to
#generate a quick RSA key for the ansible playbooks to use.

echo "" | ssh-keygen -t rsa -f ./keys/micro

#Run the playbook
ansible-playbook micro2.yml
#Refresh our inventory cache
./dyninventory/ec2.py --refresh-cache
#Run the deployment playbook. 

ansible-playbook playbooks/nginx_deploy.yml --private-key ./keys/micro -i ./dyninventory/ec2.py 

#run tests
env bash ./teststack.sh
