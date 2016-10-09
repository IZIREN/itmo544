#!/bin/bash

if [ $# != 5 ]
then
	echo "Not the proper amount of parameters: 5 needed"
else
	AMIID=$1
	KEYNAME=$2
	SECURITYGROUP=$3
	LAUNCHCONFIGURATION=$4
	COUNT=$5

	echo "DNS name of the load balancer :"
	SUBNET=`aws ec2 describe-subnets --filters "Name=availabilityZone,Values=us-west-2b" --query 'Subnets[*].SubnetId'`
	aws elb create-load-balancer --load-balancer-name itmo544-mdescos --listeners Protocol=Http,LoadBalancerPort=80,InstanceProtocol=Http,InstancePort=80 --subnets $SUBNET --security-groups $SECURITYGROUP

	aws autoscaling create-launch-configuration --launch-configuration-name $LAUNCHCONFIGURATION --image-id $AMIID --key-name $KEYNAME --instance-type t2.micro --user-data file://installenv.sh  --security-groups $SECURITYGROUP

	aws autoscaling create-auto-scaling-group --auto-scaling-group-name webserverdemo --launch-configuration $LAUNCHCONFIGURATION --availability-zone us-west-2b --max-size 5 --min-size 2 --desired-capacity $COUNT

	aws autoscaling attach-load-balancers --auto-scaling-group-name webserverdemo --load-balancer-names itmo544-mdescos

	echo "All done"
fi
