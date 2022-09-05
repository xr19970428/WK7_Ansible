#!/bin/bash
AMIList=("$(aws ec2 describe-images --owners=self --filters "Name=name,Values=*packer-demo*" --query 'Images[*].[ImageId]' --output text)")
echo "$AMIList"
for i in $AMIList
do
    echo "Destroying AMI ID: $i"
#    aws ec2 deregister-image --image-id "$i"
done
