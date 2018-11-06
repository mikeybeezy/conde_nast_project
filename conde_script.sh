#!/bin/bash


######### PARAMETERS START  #########
#AWS_REGION='eu-west-1'
#DOCKER_IMAGE_TO_BUILD='nexus2' #Should be the name of the app
#DOCKERFILE_LOCATION="./hip-tools-docker/${DOCKER_IMAGE_TO_BUILD}"
#AWS_ACCOUNT_ID="519912063470"  # poc-account-id 519912063470  | Pre Pod account ID 750714441010"
#DOCKER_IMAGE_TAG="latest"
#Add aws config deatails and balnk it OUT
#AWS Access keyID
#AWS secret Aaccess Key
#AWS region

VPC_STACK_NAME='VPC-STACK'
IAM_STACK_NAME='IAM-STACK'
APP_CLUSTER_STACK_NAME='APP-CLUSTER-STACK'


######### PARAMETERS START #########


######### AWS CONFIGURE START #########
#read -sp 'aws_account_id : ' AWS_ACCOUNT_ID
#echo "Enter the AWS ACCESS KEY ID followed by [ENTER]:"
#read -sp 'aws_access_key_id : ' ACCESS_KEY_ID
#read -sp 'aws_secret_access_key : ' SECRET_ACCESS_KEY
#read -p 'aws_default_region : ' AWS_REGION


#aws configure set aws_access_key_id $ACCESS_KEY_ID
#aws configure set aws_secret_access_key $SECRET_ACCESS_KEY
#aws configure set default.region $AWS_REGION

#echo ""
#echo "***** CLI configure complete *****"
#echo ""

######### AWS CONFIGURE END #########

echo "Creating VPC STACK"
aws cloudformation create-stack --template-body file://$PWD/vpc.yaml --stack-name ${VPC_STACK_NAME}
aws cloudformation wait stack-create-complete --stack-name  ${VPC_STACK_NAME} $STACK_ID_FROM_CREATE_STACK
echo "Creating Stack for IAM roles"
aws cloudformation create-stack --template-body file://$PWD/iam.yaml --stack-name ${IAM_STACK_NAME} --capabilities CAPABILITY_IAM
aws cloudformation wait stack-create-complete --stack-name ${IAM_STACK_NAME} $STACK_ID_FROM_CREATE_STACK
echo "Creating App cluster and Resources"
aws cloudformation create-stack --template-body file://$PWD/app-cluster.yaml --stack-name ${APP_CLUSTER_STACK_NAME}
aws cloudformation wait stack-create-complete --stack-name ${APP_CLUSTER_STACK_NAME} $STACK_ID_FROM_CREATE_STACK
