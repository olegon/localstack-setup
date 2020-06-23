FROM local/localstack-setup

COPY ./create-stack.sh /create-stack.sh

ENV CREATE_RESOURCES_SCRIPT /create-stack.sh
ENV SERVICES_TO_WAIT="s3 dynamodb"
ENV AWS_ACCESS_KEY_ID=test
ENV AWS_SECRET_ACCESS_KEY=test
ENV AWS_DEFAULT_REGION=sa-east-1
