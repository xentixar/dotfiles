#!/bin/bash

ROLE_ARN="arn:aws:iam::465820258692:role/ecr_access_role"
REGION="us-east-2"
ACCOUNT_ID="465820258692"
CREDS=$(aws sts assume-role --role-arn $ROLE_ARN --role-session-name ECRAccessSession)

ACCESS_KEY=$(echo $CREDS | jq -r '.Credentials.AccessKeyId')
SECRET_KEY=$(echo $CREDS | jq -r '.Credentials.SecretAccessKey')
SESSION_TOKEN=$(echo $CREDS | jq -r '.Credentials.SessionToken')

export AWS_ACCESS_KEY_ID="$ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY="$SECRET_KEY"
export AWS_SESSION_TOKEN="$SESSION_TOKEN"

echo "Logging in to ECR..."
aws ecr get-login-password --region "$REGION" | docker login --username AWS --password-stdin "$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com"
