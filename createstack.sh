#!/usr/bin/env bash

#Create Keypair for us to use
#In reality, we probably need a better way of securing this key.
#Alternatively, use a keystore, or already have the key generated.
#For the purposes of this exercise, I included this stub code to
#generate a quick RSA key for the ansible playbooks to use.

echo "" | ssh-keygen -t rsa -f ./keys/micro

#Run the playbook
ansible-playbook ./playbooks/micro.yml


#run tests
env bash ./teststack.sh
