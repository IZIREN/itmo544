#!/bin/bash

echo "DNS name of the load balancer :"
SUBNET=`aws ec2 describe-subnets --filters "Name=availabilityZone,Values=us-west-2b" --query 'Subnets[*].SubnetId'`
aws elb create-load-balancer --load-balancer-name itmo544-mdescos --listeners Protocol=Http,LoadBalancerPort=80,InstanceProtocol=Http,InstancePort=80 --subnets $SUBNET --security-groups sg-1a39c263

aws autoscaling create-launch-configuration --launch-configuration-name webserver --image-id $1 --key-name macmax3 --instance-type t2.micro --user-data file://installenv.sh  --security-groups sg-1a39c263

aws autoscaling create-auto-scaling-group --auto-scaling-group-name webserverdemo --launch-configuration webserver --availability-zone us-west-2b --max-size 5 --min-size 2 --desired-capacity 4

aws autoscaling attach-load-balancers --auto-scaling-group-name webserverdemo --load-balancer-names itmo544-mdescos

echo "All done"
