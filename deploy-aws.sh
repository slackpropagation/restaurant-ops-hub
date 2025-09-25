#!/bin/bash

# AWS Deployment Script for Restaurant Ops Hub
set -e

echo "🚀 Starting AWS deployment for Restaurant Ops Hub..."

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI is not installed. Please install it first."
    echo "Visit: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
    exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install it first."
    echo "Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

echo "✅ Prerequisites check passed"

# Get AWS account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
AWS_REGION="us-east-1"
ECR_REPOSITORY="restaurant-ops-hub"

echo "📦 Building Docker image..."
docker build -t restaurant-ops-hub .

echo "🏷️ Tagging image for ECR..."
docker tag restaurant-ops-hub:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY:latest

echo "🔐 Logging in to ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

echo "📤 Pushing image to ECR..."
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY:latest

echo "✅ Backend deployment completed!"
echo "🔗 Next steps:"
echo "1. Create RDS PostgreSQL database"
echo "2. Deploy to AWS App Runner"
echo "3. Deploy frontend to AWS Amplify"
echo "4. Update environment variables"

echo "📋 Manual steps required:"
echo "- Create RDS instance: https://console.aws.amazon.com/rds/"
echo "- Create App Runner service: https://console.aws.amazon.com/apprunner/"
echo "- Create Amplify app: https://console.aws.amazon.com/amplify/"
