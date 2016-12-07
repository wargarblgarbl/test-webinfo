# Ansible/CloudFormation Setup/Testing/Teardown scripts

###dependencies
- Python - everything has been tested with python 2.7
- Ansible - Installation instructions: http://docs.ansible.com/ansible/intro_installation.html
- awscli - Installation instructions:  http://docs.aws.amazon.com/cli/latest/userguide/installing.html
- bash - the shell scripting portions of these scripts are written in bash, and possibly contain bashisms.
- jq - the test script does some json processing right in bash. 
- dynamic ansible inventory script for aws. If missing, the scripts will automatically grab it, however, the ini file is provided in the repository as-is. 

###instructions
- To spin up and run automated tests on the stack  
-- Clone repository  
-- execute `./createstack2.sh`  
- To run automated tests  
-- execute `./teststack.sh`  
- To tear down the stack  
-- execute `./deletestack.sh`

If you need to ssh into a running instance, the keys are located in `./keys`, this folder is created on demand when `createstack2.sh` is run. 


###createstack2.sh
This script is the big cahuna, so to speak. It runs a playbook to provision our stack, then runs another playbook to deploy our configuration and deployable artifacts, and then runs some tests.


###the stack
An ELB that fronts at least two nginx nodes serving static content. 


###room for improvement
Plenty of room for improvement here. Among the things to possibly consider going forward (in no particular order):

1. Standardize on the ansible best-practices directory layout. Right now things are a little bit more chaotic than they need to be.

2. Break up the nginx-deploy playbook into several minor roles. We may want to re-use them at a later time. The wait for SSH bit specifically comes to mind.

3. Template the cloudformation bits - investigate if it's possible to template this out further. 

4. Get away from hardcoding AWS regions. For the purposes of this exercise, chosing US-WEST-2 seemed relatively sane. It also got around a few issues with the dynamic inventory script, which would fail, as the default options in the ini provided do not appear to be sane, and the script fails.

5. Security - right now, for the purposes of demonstration, the security group that is created allows SSH access to all machines on 0.0.0.0/0, which is not a good idea in the real world.

6. Provision additional bits - we could easily expand this to spin up an entirely new VPC, and then all of the underlying infrastructure. For now, I felt this was a little bit out of scope for this exercise.

7. Security^2. Key storage is something to think about. Potentially with this setup I would consider going to something ala ansible vault. 

8. Currently the testing script has no real knowledge of the ELB status. Perhaps the test would be better if we could see if the ELB was truly up.

9. Timing as a whole - I would want to run a lot more tests to determine that everything was going off as necessary. On OSX, everything comes up as intended, on FreeBSD, the second playbook sometimes fails due to timing not being quite right. 

10. After a bit more refactoring, the bash script should contain reference to a single ansible playbook, that would, during the provisioning process call the nginx_deploy playbook, instead of doing it the hackneyd way I am doing it now. 

11. Straight on the heels of 10, testing needs to be improved. Doing it as a bash script is fine on a small scale, but I *really* want to offload this to a proper test setup. 


###legacy
The legacy variant of this script is available in `/legacy/createstack.sh` and the corresponding ansible yaml file. This is the very first attempt at this task, and features an number of not so great decisions, including using the cloudformation tempalte itself to install nginx and dynamically pull the configuration and deployable files from github.

While this could have been a "correct" solution, it suffers from a number of issues. It's not every extensible, it only provisions one server, and doesn't particularly leverage the capabilities of the provided platform, and it offloads configuration management from the configuration management software to another tool, which isn't great.

On the plus side - it's very readable and fairly concise. It wouldn't be too hard to turn it into something a tad more robust. 

###quirks
When running `createstack2.sh` on a FreeBSD host, the `nginx-deploy` playbook will fail for up to 60 seconds after the initial deployment goes through. 

TODO: Investigate, potentially needs a bug report filed with the ansible team. 
