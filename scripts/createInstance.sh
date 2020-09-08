#! /bin/bash
#
# createInstance.sh
# 2020-09-01
# CC-0 Public Domain


set -eux # be safe

KEY_PAIR=${KEY_PAIR:=colton_lobster}
SEC_GROUP_NAME=${SEC_GROUP_NAME:=default}
IMAGE_ID=${IMAGE_ID:=resolve:ssm:/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2}
INSTANCE_TYPE=${INSTANCE_TYPE:=t2.micro}
INSTANCE_COUNT=${INSTANCE_COUNT:=1}

VPC_ID=$(aws ec2 describe-vpcs --filter Name=tag:Name,Values=ccg-default-vpc --query 'Vpcs[0].VpcId' --output text)
SUBNET_ID=$(aws ec2 describe-subnets --filters Name=vpc-id,Values=${VPC_ID} --query "Subnets[0].SubnetId" --output text)
SEC_GROUP_ID=$(aws ec2 describe-security-groups --filters Name=vpc-id,Values=${VPC_ID} Name=group-name,Values=${SEC_GROUP_NAME} --query 'SecurityGroups[0].GroupId' --output text)

aws ec2 run-instances \
	--image-id $IMAGE_ID \
	--count $INSTANCE_COUNT \
	--instance-type $INSTANCE_TYPE \
	--key-name $KEY_PAIR \
	--security-group-ids $SEC_GROUP_ID \
	--subnet-id $SUBNET_ID
