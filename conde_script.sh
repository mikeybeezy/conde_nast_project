#!/bin/bash
set -e

######### PARAMETERS START  #########
#AWS_REGION='eu-west-1'
#DOCKER_IMAGE_NAME='nexus2' #Should be the name of the app
#DOCKERFILE_LOCATION="./hip-tools-docker/${DOCKER_IMAGE_NAME}"
#AWS_ACCOUNT_ID="519912063470"  # poc-account-id 519912063470  | Pre Pod account ID 750714441010"
#DOCKER_IMAGE_TAG="latest"
#Add aws config deatails and balnk it OUT
#AWS Access keyID
#AWS secret Aaccess Key
#AWS region

VPC_STACK_NAME='VPC-STACK'
IAM_STACK_NAME='IAM-STACK'
APP_CLUSTER_STACK_NAME='APP-CLUSTER-STACK'
AWS_REGION='eu-west-1'
DOCKER_IMAGE_NAME='hello-world-app'
DOCKERFILE_LOCATION="${PWD}/sample-nodejs-app/."
AWS_ACCOUNT_ID="519912063470"
DOCKER_IMAGE_TAG="latest"

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
#!/bin/bash#!/bin/bash -e

#set path for where directory where git reposotry will be cloned into on local device
#REPO_TO_CLONE='http://gitlab.kingfisher.digital/infra/hip-tools-docker.git'

#519912063470
#echo "Enter the AWS ACCESS KEY ID followed by [ENTER]:"


# #read -sp 'aws_account_id : ' AWS_ACCOUNT_ID
# echo "Enter the AWS ACCESS KEY ID followed by [ENTER]:"
# read -sp 'aws_access_key_id : ' ACCESS_KEY_ID
# read -sp 'aws_secret_access_key : ' SECRET_ACCESS_KEY
# read -p 'aws_default_region : ' AWS_REGION

#
# aws configure set aws_access_key_id $ACCESS_KEY_ID
# aws configure set aws_secret_access_key $SECRET_ACCESS_KEY
# aws configure set default.region $AWS_REGION
#
# echo ""
# echo "***** CLI configure complete *****"
# echo ""
#

# if [ -d hip-tools-docker ]; then
#   echo "***** Local repo already exists *****"
# else git clone ${REPO_TO_CLONE}
#
# fi

# ###### Check to see if repository exists #########
# function check_repo_name() {
#   echo  "$(aws ecr describe-repositories | jq ".repositories[] | select(.repositoryName==\"${APP_REPOSITORY_NAME}\")")"
# }
# if check_repo_name == "${DOCKER_IMAGE_NAME}"; then
#   echo "${DOCKER_IMAGE_NAME} Repository Already Exists"
# else aws ecr create-repository --repository-name ${DOCKER_IMAGE_NAME}
#
# fi

# AWS CREATE REPOSITIRY
echo "Creating Docker AWS ECR Image Repository"
aws ecr create-repository --repository-name ${DOCKER_IMAGE_NAME}
#Token authentication to repository
$(aws ecr get-login --no-include-email --region ${AWS_REGION})

echo "Building Docker Image"
docker build -t  ${DOCKER_IMAGE_NAME} ${DOCKERFILE_LOCATION}

#Tag image
docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}

echo "Pushing Docker Image To ECR Repository"
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}

#need to put a conditional on this message so that if the message is only displayed when the image is successfully built and pushed
echo ""
echo "Image successfully pushed to ECR repository ${DOCKER_IMAGE_NAME}"
echo ""

#dockerDo you want to remove repository

echo "Creating VPC STACK"
aws cloudformation create-stack --template-body file://$PWD/vpc.yaml --stack-name ${VPC_STACK_NAME}
aws cloudformation wait stack-create-complete --stack-name  ${VPC_STACK_NAME} $STACK_ID_FROM_CREATE_STACK
echo "Creating Stack for IAM roles"
aws cloudformation create-stack --template-body file://$PWD/iam.yaml --stack-name ${IAM_STACK_NAME} --capabilities CAPABILITY_IAM
aws cloudformation wait stack-create-complete --stack-name ${IAM_STACK_NAME} $STACK_ID_FROM_CREATE_STACK
echo "Creating App cluster and Resources"
aws cloudformation create-stack --template-body file://$PWD/app-cluster.yaml --stack-name ${APP_CLUSTER_STACK_NAME}
aws cloudformation wait stack-create-complete --stack-name ${APP_CLUSTER_STACK_NAME} $STACK_ID_FROM_CREATE_STACK
