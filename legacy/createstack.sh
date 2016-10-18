#!/usr/bin/env bash
#Export some global variables
export ANSIBLE_HOSTS=`pwd`/dyninventory/ec2.py
export EC2_INI_PATH=`pwd`/dyninventory/ec2.ini
export ANSIBLE_HOST_KEY_CHECKING=false

#Create Keypair for us to use
#In reality, we probably need a better way of securing this key.
#Alternatively, use a keystore, or already have the key generated.
#For the purposes of this exercise, I included this stub code to
#generate a quick RSA key for the ansible playbooks to use.

if [ ! -d keys ]; then
    mkdir keys
fi

#Generate the key we're going to be using
echo "" | ssh-keygen -t rsa -f ./keys/micro

#Run the playbook
ansible-playbook micro.yml

#refresh inventory cash
$ANSIBLE_HOSTS --refresh-cache

#run tests
env bash ./teststack.sh
