# Deploy a simple docker container Node.js hello world Appp in AWS ECS

The shell script conde_script.sh is design to run through the entire installation process. the script will create 4 cloudformation stacks and and finally deploy the hello world app.

The Out

## Configure the aws CLI ensure you have the AWS CLI instilled 
If you dont have the AWS Cli installd you can do so by navigating to the link below and following the steps.
https://docs.aws.amazon.com/cli/latest/userguide/installing.html

## 1. You will be prompted to enter your aws user access key and secret access key Id
This will enable you to run the start up script with you AWS user account credentials and user priviliages


## 2. In your terminal run the script conde_script.sh 
The script will then run through all the  necessery steps to create the CloudFormation stacks, the ECS cluster and deploy the hello world application into the cluster.
