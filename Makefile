ENV_TYPE := dev
PROJECT_PREFIX_LOWER := prj

TEMPLATE_DIR := code_series/cloudformation_templates
PARAMETERS_DIR := code_series/parameters

BASE_RESOURCES_TEMPLATE_FILE := 00_base_resources.yml
PIPELINE_TEMPLATE_FILE := 01_pipeline.yml

BASE_RESOURCES_STACK_NAME := $(PROJECT_PREFIX_LOWER)-$(ENV_TYPE)-base-resources
PIPELINE_STACK_NAME := $(PROJECT_PREFIX_LOWER)-$(ENV_TYPE)-pipeline

version: ## Show version of aws-cli
	@aws --version

account: ## Show account id
	@aws sts get-caller-identity --output text --query 'Account'

00_base_resources: ## Connect GitHub repo and AWS account. This needs to be run only once
	@aws cloudformation deploy \
	--stack-name $(BASE_RESOURCES_STACK_NAME) \
	--template "$(TEMPLATE_DIR)/${BASE_RESOURCES_TEMPLATE_FILE}" \
	--parameter-overrides "file://code_series/parameters/$(PROJECT_PREFIX_LOWER).$(ENV_TYPE).json" \
	--capabilities CAPABILITY_IAM

01_pipeline: ## Create CodePipeline
	@aws cloudformation deploy \
	--stack-name $(PIPELINE_STACK_NAME) \
	--template "$(TEMPLATE_DIR)/${PIPELINE_TEMPLATE_FILE}" \
	--parameter-overrides "file://code_series/parameters/$(PROJECT_PREFIX_LOWER).$(ENV_TYPE).json" \
	--capabilities CAPABILITY_IAM

help: ## List all available commands
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
