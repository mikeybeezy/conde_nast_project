#!/bin/bash
set -e

######### PARAMETERS START  #########
#Add aws config deatails and balnk it OUT
#AWS Access keyID
#AWS secret Aaccess Key

VPC_STACK_NAME='VPC-STACK'
IAM_STACK_NAME='IAM-STACK'
APP_CLUSTER_STACK_NAME='APP-CLUSTER-STACK'
APP_DEPLOYMENT_STACK='HELLO-WORLD-APP'
AWS_REGION='eu-west-1'
DOCKER_IMAGE_NAME='hello-world-app'
DOCKERFILE_LOCATION="${PWD}/sample-nodejs-app/."
AWS_ACCOUNT_ID="519912063470"
DOCKER_IMAGE_TAG="latest"
DOCKER_IMAGE_REPO="${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"

######### PARAMETERS END #########

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

#AWS CREATE REPOSITIRY
echo '#### Creating Docker AWS ECR Image Repository ####'
aws ecr create-repository --repository-name ${DOCKER_IMAGE_NAME}

#TOKEN AUTHENTICATION TO ECR REPOSITORY
$(aws ecr get-login --no-include-email --region ${AWS_REGION})

echo '#### Building Docker Image ####'
docker build -t  ${DOCKER_IMAGE_NAME} ${DOCKERFILE_LOCATION}

#TAG IMAGE
docker tag ${DOCKER_IMAGE_REPO}

echo '#### Pushing Docker Image To ECR Repository ####'
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}

#need to put a conditional on this message so that if the message is only displayed when the image is successfully built and pushed

echo "Image ${DOCKER_IMAGE_NAME} successfully pushed to ECR repository"

echo '#### Creating VPC STACK ####'
aws cloudformation create-stack --template-body file://$PWD/vpc.yaml --stack-name ${VPC_STACK_NAME}
aws cloudformation wait stack-create-complete --stack-name  ${VPC_STACK_NAME} $STACK_ID_FROM_CREATE_STACK

echo '#### Creating Stack for IAM roles ####'
aws cloudformation create-stack --template-body file://$PWD/iam.yaml --stack-name ${IAM_STACK_NAME} --capabilities CAPABILITY_IAM
aws cloudformation wait stack-create-complete --stack-name ${IAM_STACK_NAME} $STACK_ID_FROM_CREATE_STACK

echo '#### Creating App cluster and Resources ####'
aws cloudformation create-stack --template-body file://$PWD/app-cluster.yaml --stack-name ${APP_CLUSTER_STACK_NAME}
aws cloudformation wait stack-create-complete --stack-name ${APP_CLUSTER_STACK_NAME} $STACK_ID_FROM_CREATE_STACK
