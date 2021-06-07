#!/bin/bash
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text --profile default)
REGION=$(aws configure get region --profile default)
TEMPLATE_FILE="develop.yml"
STACK_NAME="EcsOnFargate"
application_image_name="app:latest"
web_image_name="web:latest"

function blue(){
    tput setaf 6 && echo $1 && tput sgr0
}

if [ "build" = $1 ] ; then
	blue "Build Docker Images"
    dir=${PWD}
	cd ${dir}/Fargate/app && docker image build -t ${application_image_name} .
	cd ${dir}/Fargate/web && docker image build -t ${web_image_name} .
    cd ${dir}
elif [ "cicd" = $1 ] ; then
	blue "Deploy CICD Tools"
	cd CICD && aws cloudformation deploy --template-file CICD.yml --stack-name CICD
elif [ "deploy" = $1 ] ; then
    aws cloudformation deploy \
        --template-file ${TEMPLATE_FILE} \
        --stack-name ${STACK_NAME} \
        --capabilities CAPABILITY_NAMED_IAM \
	 --profile default
elif [ "exec" = $1 ] ; then
	blue "Execute Docker container"
	docker container exec -it $2 sh
elif [ "login" = $1 ] ; then
	blue "Login ECR"
	$(aws ecr get-login --no-include-email --profile default)
elif [ "push" = $1 ] ; then
	blue "Push Docker Images"
	docker image push ${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/app
	docker image push ${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/web
elif [ "rmc" = $1 ] ; then
	blue "Remove All Docker Containers"
	docker container ps -aq | xargs docker container rm -f
elif [ "rmi" = $1 ] ; then
	blue "Remove All Docker Images"
	docker image ls -aq | xargs docker image rm -f
elif [ "run" = $1 ] ; then
	blue "Run Docker container"
	echo $(docker container run -itd -p 3000:3000 ${application_image_name})
elif [ "tag" = $1 ] ; then
	blue "Tag the Docker image with Repositry"
	docker image tag ${application_image_name} ${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/app
	docker image tag ${web_image_name} ${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/web
fi
