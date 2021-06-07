.PHONY: build
.PHONY: cicd
.PHONY: deploy
.PHONY: exec
.PHONY: login
.PHONY: push
.PHONY: package
.PHONY: put
.PHONY: rmc
.PHONY: rmi
.PHONY: run
.PHONY: tag
AWS_ACCOUNT_ID := $(shell aws sts get-caller-identity --query Account --output text --profile default)
REGION := $(shell aws configure get region --profile default)
TEMPLATE_FILE := develop.yml
STACK_NAME := EcsOnFargate
application_image_name := app:latest
web_image_name := web:latest
# Give me Container ID that is running and you want to execute something within it.
# ex) make exec container_id=xxxxxx
container_id := container_id

build:
	$(call blue , "Build Docker Images")
	@cd Fargate/app && docker image build -t $(application_image_name) .
	@cd Fargate/web && docker image build -t $(web_image_name) .
cicd:
	$(call blue , "Deploy CICD Tools")
	@cd CICD && aws cloudformation deploy --template-file CICD.yml --stack-name CICD
deploy:
	$(call blue , "Deploy CloudFormation Stack")
	@aws cloudformation deploy --template-file $(TEMPLATE_FILE) --stack-name $(STACK_NAME) --profile default
exec:
	$(call blue , "Execute Docker container")
	@docker container exec -it $(container_id) sh
login:
	$(call blue , "Login ECR")
	@$(shell aws ecr get-login --no-include-email --profile default)
push:
	$(call blue , "Push Docker Images")
	@docker image push $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com/app
	@docker image push $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com/web
rmc:
	$(call blue , "Remove All Docker Containers")
	@docker container ps -aq | xargs docker container rm -f
rmi:
	$(call blue , "Remove All Docker Images")
	@docker image ls -aq | xargs docker image rm -f
run:
	$(call blue , "Run Docker container")
	@echo $(shell docker container run -itd -p 3000:3000 $(application_image_name))
tag:
	$(call blue , "Tag the Docker image with Repositry")
	@docker image tag $(application_image_name) $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com/app
	@docker image tag $(web_image_name) $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com/web

define blue
	@tput setaf 6 && echo $1 && tput sgr0
endef
