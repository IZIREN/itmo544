#!/bin/bash

GROUPNAME=`aws autoscaling describe-auto-scaling-groups --query 'AutoScalingGroups[*].AutoScalingGroupName'`
echo $GROUPNAME
LOADBALANCERNAME=`aws autoscaling describe-auto-scaling-groups --query 'AutoScalingGroups[*].LoadBalancerNames'`
echo $LOADBALANCERNAME
CONFIGURATIONNAME=`aws autoscaling describe-launch-configurations --query 'LaunchConfigurations[*].LaunchConfigurationName'`
echo $CONFIGURATIONNAME
ID=`aws autoscaling describe-auto-scaling-instances --query 'AutoScalingInstances[].InstanceId'`
echo $ID
PORT=`aws elb describe-load-balancers --load-balancer-names $LOADBALANCERNAME --query 'LoadBalancerDescriptions[*].ListenerDescriptions[*].Listener[].LoadBalancerPort'`
echo $PORT
POLICYNAME=`aws elb describe-load-balancer-policies --load-balancer-name $LOADBALANCERNAME --query 'PolicyDescriptions[*].PolicyName'`

aws autoscaling update-auto-scaling-group --auto-scaling-group-name $GROUPNAME --launch-configuration-name $CONFIGURATIONNAME --min-size 0 --max-size 0 --desired-capacity 0
aws autoscaling detach-load-balancers --auto-scaling-group-name $GROUPNAME --load-balancer-names $LOADBALANCERNAME
aws ec2 wait instance-terminated --instance-ids $ID

aws autoscaling delete-auto-scaling-group --auto-scaling-group-name $GROUPNAME

aws autoscaling delete-launch-configuration --launch-configuration-name $CONFIGURATIONNAME

aws elb deregister-instances-from-load-balancer --load-balancer-name $LOADBALANCERNAME --instances $ID

aws elb delete-load-balancer-listeners --load-balancer-name $LOADBALANCERNAME --load-balancer-ports $PORT
aws elb delete-load-balancer-policy --load-balancer-name $LOADBALANCERNAME --policy-name $POLICYNAME

aws elb  delete-load-balancer --load-balancer-name $LOADBALANCERNAME

aws ec2 terminate-instances --instance-ids $ID

