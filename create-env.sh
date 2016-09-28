#!/bin/bash

DATE=`date +%Y-%m-%d:%H:%M:%S`
TOKEN=$DATE'-itmo544-mdescos'
echo $TOKEN

aws ec2 run-instances --image-id ami-06b94666 --key-name macmax3 --security-group-ids sg-1a39c263 --instance-type t2.micro --count 3 --user-data file://installenv.sh --placement AvailabilityZone=us-west-2b --client-token $TOKEN

ID=`aws ec2 describe-instances --filters "Name=client-token,Values=$TOKEN" --query 'Reservations[*].Instances[].InstanceId'`
echo $ID

aws ec2 wait instance-running --instance-ids $ID --filters "Name=client-token,Values=$TOKEN"

SUBNET=`aws ec2 describe-subnets --filters "Name=availabilityZone,Values=us-west-2b" --query 'Subnets[*].SubnetId'`
aws elb create-load-balancer --load-balancer-name itmo544-mdescos --listeners Protocol=Http,LoadBalancerPort=80,InstanceProtocol=Http,InstancePort=80 --subnets $SUBNET --security-groups sg-1a39c263

aws elb register-instances-with-load-balancer --load-balancer-name itmo544-mdescos --instances $ID

aws autoscaling create-launch-configuration --launch-configuration-name webserver --image-id ami-06b94666 --key-name macmax3 --instance-type t2.micro --user-data file://installenv.sh  --security-groups sg-1a39c263

aws autoscaling create-auto-scaling-group --auto-scaling-group-name webserverdemo --launch-configuration webserver --availability-zone us-west-2b --max-size 5 --min-size 2 --desired-capacity 4

aws autoscaling attach-load-balancers --auto-scaling-group-name webserverdemo --load-balancer-names itmo544-mdescos
