# itmo544

Lab from the ITMO 544 - Cloud Computing Technologies

The scripts will create/destroy a cloud infrascture with a load balancer according to a few parameters given by the user (see the commands below).
It will also create an small website on the servers.

create-env.sh creates a autoscaling group with a load balancer
command to launch it: ./create-env.sh ami-id (for example ami-06b94666) key-name security-groups name-of-the-launch-configuration desired-number-of-instances(between 2 and 5)

destroy-env.sh destroy the environment created before automatically
./destro-env.sh

installenv.sh is the installation script on the instances with a website.
