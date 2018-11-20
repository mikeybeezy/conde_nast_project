# Deploy a simple docker container Node.js hello world Appp in AWS ECS

The shell script conde_script.sh is design to run through the entire installation process. the script will create 4 cloudformation stacks and and finally deploy the hello world app.

## Configure the aws CLI ensure you have the AWS CLI instilled 
If you dont have the AWS Cli installd you can do so by navigating to the link below and following the steps.
https://docs.aws.amazon.com/cli/latest/userguide/installing.html


## 1. Clone the git repo

## 2. Follow prompts and enter aws user access key and secret access key Id
This will enable you to run the conde_script.sh  start up script with you AWS user account credentials and user priviliages


## 3. In your terminal run the script conde_script.sh 
The script will then run through all the  necessery steps to create the CloudFormation stacks, the ECS cluster and the deployment of the hello world application into the  ECS cluster. 
In order to run the script you will should  specfiy the relative or absoulte path o
