#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -o nounset
set -e
# This script shows how to build the Docker image and push it to ECR to be ready for use
# by SageMaker.

# The argument to this script is the image name. This will be used as the image on the local
# machine and combined with the account and region to form the repository name for ECR.
image=boltz2
account=370161337578
region=us-west-2
profile=default


fullname="${account}.dkr.ecr.${region}.amazonaws.com/${image}:latest"

# Get the login command from ECR and execute it directly
aws ecr get-login-password --region $region --profile $profile | docker login --username AWS --password-stdin $account.dkr.ecr.$region.amazonaws.com

# Get the login command from ECR in order to pull down the SageMaker PyTorch image
aws ecr get-login-password --region $region --profile $profile | docker login --username AWS --password-stdin $account.dkr.ecr.$region.amazonaws.com

# Build the docker image locally with the image name and then push it to ECR
# with the full name.
DOCKER_BUILDKIT=1 docker image build  --ssh=default -t ${image} . --build-arg REGION=${region}
docker tag ${image} ${fullname}
docker push ${fullname}