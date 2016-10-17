#!/usr/bin/env bash

echo "Running tests"
if [ ! -f ec2.py ]; then
    curl -s https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.py > ec2.py
    chmod +x ec2.py
fi

#Use ansible to see if we have hosts up
echo "Checking to see if server is accessible by ansible"
ansible -i ec2.py -m ping type_t2_micro -u ec2-user --private-key ./keys/micro


#Abuse of the amazon dynamic inventory script to run a command against eveything tagged "type_t2_micro"
#We could theoretically use a completely different variable to filter by, but since we don't have anything else
#yet, this is as good as anything else
echo "checking deployable diff"
for i in `python ec2.py --list | jq '.type_t2_micro[]' | sed s/\"//g`; do
	   curl -s  $i/index.html > /tmp/test_index.html
	   diff_output=$(diff -bB /tmp/test_index.html deployable/index.html | wc -l)
	   if (( diff_output > 0 )); then
	       echo "FAIL: server [$i] output does not match deployable"
	   else
	       echo "PASS: server [$i] deployed successfully"
	   fi
           rm /tmp/test_index.html
done	

if [ -f loadbalancer.out ]; then
    echo "Testing load balancer"
    lb=$(cat loadbalancer.out | cut -d "'" -f4)
    curl -s $lb > /tmp/test_lb.html
    diff_output=$(diff -bB /tmp/test_lb.html deployable/index.html | wc -l)
    if (( diff_output > 0 )); then
	echo "FAIL: loadbalancer [$lb] does not match deployable or is serving nothing and is most likely still starting up"
    else
	echo "PASS: loadbalancer [$lb] deployed successfully"
    fi
    rm /tmp/test_lb.html
fi
