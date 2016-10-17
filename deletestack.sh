#!/usr/bin/env/bash
ansible-playbook ./playbooks/teardown.yml
rm -rf ./keys/micro*
if [ -f loadbalancer.out ]; then
rm -f loadbalancer.out
fi
rm -f ./playbooks/*retry
