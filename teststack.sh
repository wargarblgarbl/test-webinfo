#!/usr/bin/env bash

echo "Running tests"
if [ ! -f ec2.py ]; then
    curl -s https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.py > ec2.py
    chmod +x ec2.py
fi

#Use ansible to see if we have hosts up
echo "Checking if server is up"
ansible -i ec2.py -m ping tag_Name_WebServer -u ec2-user --private-key ./keys/micro


#Abuse of the amazon dynamic inventory script to run a command against eveything tagged "application web nginx"
echo "checking deployable diff"
for i in `python ec2.py --list | jq '.tag_Name_WebServer[]' | sed s/\"//g`; do
	   curl -s  $i/index.html > /tmp/test_index.html
	   diff_output=$(diff -bB /tmp/test_index.html deployable/index.html | wc -l)
	   if (( diff_output > 0 )); then
	       echo "FAIL: server [$i] output does not match deployable"
	   else
	       echo "PASS: server [$i] deployed successfully"
	   fi
           rm /tmp/test_index.html
done	
 
