# itmo544

Lab from the ITMO 544 - Cloud Computing Technologies

create-env.sh creates a autoscaling group with a load balancer
command to launch it: ./create-env.sh ami-id (for example ami-06b94666) key-name security-groups name-of-the-launch-configuration desired-number-of-instances(between 2 and 5)

destroy-env.sh destroy the environment created before automatically
./destro-env.sh

installenv.sh is the installation script on the instances with a website.
