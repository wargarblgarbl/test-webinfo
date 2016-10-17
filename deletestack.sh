#!/usr/bin/env/bash
ansible-playbook ./playbooks/teardown.yml
rm -rf ./keys/*
rm -f ./playbooks/*retry
