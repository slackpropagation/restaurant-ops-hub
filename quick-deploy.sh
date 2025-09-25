#!/bin/bash

# Quick Deploy Script for Restaurant Ops Hub on AWS
set -e

echo "🚀 Restaurant Ops Hub - Quick AWS Deployment"
echo "=============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check prerequisites
print_status "Checking prerequisites..."

if ! command -v aws &> /dev/null; then
    print_error "AWS CLI is not installed. Please install it first."
    echo "Visit: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
    exit 1
fi

if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install it first."
    echo "Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

if ! command -v npm &> /dev/null; then
    print_error "Node.js/npm is not installed. Please install it first."
    echo "Visit: https://nodejs.org/"
    exit 1
fi

print_success "All prerequisites are installed!"

# Get AWS account info
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
AWS_REGION="us-east-1"
STACK_NAME="restaurant-ops-hub"

print_status "AWS Account: $AWS_ACCOUNT_ID"
print_status "Region: $AWS_REGION"

# Step 1: Deploy Infrastructure
print_status "Step 1: Deploying AWS infrastructure..."
aws cloudformation create-stack \
  --stack-name $STACK_NAME \
  --template-body file://aws-infrastructure.yaml \
  --parameters ParameterKey=DatabasePassword,ParameterValue=RestaurantOps123! \
  --capabilities CAPABILITY_IAM \
  --region $AWS_REGION

print_status "Waiting for infrastructure deployment (this may take 5-10 minutes)..."
aws cloudformation wait stack-create-complete --stack-name $STACK_NAME --region $AWS_REGION

print_success "Infrastructure deployed successfully!"

# Get outputs
DB_ENDPOINT=$(aws cloudformation describe-stacks \
  --stack-name $STACK_NAME \
  --query 'Stacks[0].Outputs[?OutputKey==`DatabaseEndpoint`].OutputValue' \
  --output text \
  --region $AWS_REGION)

ECR_URI=$(aws cloudformation describe-stacks \
  --stack-name $STACK_NAME \
  --query 'Stacks[0].Outputs[?OutputKey==`ECRRepositoryURI`].OutputValue' \
  --output text \
  --region $AWS_REGION)

print_status "Database Endpoint: $DB_ENDPOINT"
print_status "ECR Repository: $ECR_URI"

# Step 2: Build and Push Backend
print_status "Step 2: Building and pushing backend to ECR..."

# Build Docker image
print_status "Building Docker image..."
docker build -t restaurant-ops-hub .

# Tag and push to ECR
print_status "Tagging and pushing to ECR..."
docker tag restaurant-ops-hub:latest $ECR_URI:latest

# Login to ECR
print_status "Logging in to ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URI

# Push image
print_status "Pushing image to ECR..."
docker push $ECR_URI:latest

print_success "Backend image pushed to ECR!"

# Step 3: Create App Runner Service
print_status "Step 3: Creating App Runner service..."

# Create App Runner service configuration
cat > apprunner-service.json << EOF
{
  "ServiceName": "restaurant-ops-api",
  "SourceConfiguration": {
    "ImageRepository": {
      "ImageIdentifier": "$ECR_URI:latest",
      "ImageConfiguration": {
        "Port": "8000",
        "RuntimeEnvironmentVariables": {
          "DATABASE_URL": "postgresql://restaurantops:RestaurantOps123!@$DB_ENDPOINT:5432/restaurant_ops",
          "PYTHONPATH": "/app",
          "ENVIRONMENT": "production"
        }
      },
      "ImageRepositoryType": "ECR"
    },
    "AutoDeploymentsEnabled": true
  },
  "InstanceConfiguration": {
    "Cpu": "0.25 vCPU",
    "Memory": "0.5 GB"
  }
}
EOF

# Create App Runner service
aws apprunner create-service \
  --cli-input-json file://apprunner-service.json \
  --region $AWS_REGION

print_success "App Runner service created!"

# Step 4: Build Frontend
print_status "Step 4: Building frontend for Amplify..."

cd apps/web
npm install
npm run build
cd ../..

print_success "Frontend built successfully!"

# Step 5: Display next steps
print_success "🎉 Deployment completed successfully!"
echo ""
echo "📋 Next Steps:"
echo "=============="
echo ""
echo "1. 🌐 Create AWS Amplify App:"
echo "   - Go to: https://console.aws.amazon.com/amplify/"
echo "   - Click 'New app' → 'Host web app'"
echo "   - Connect your Git repository"
echo "   - Use the amplify.yml configuration"
echo ""
echo "2. 🔧 Get your App Runner URL:"
echo "   - Go to: https://console.aws.amazon.com/apprunner/"
echo "   - Find your 'restaurant-ops-api' service"
echo "   - Copy the service URL"
echo ""
echo "3. ⚙️ Configure Frontend:"
echo "   - In Amplify, add environment variable:"
echo "   - VITE_API_URL = [Your App Runner URL]"
echo ""
echo "4. 🗄️ Initialize Database:"
echo "   - Connect to your RDS instance"
echo "   - Run the migration and seed scripts"
echo ""
echo "5. 🚀 Deploy Frontend:"
echo "   - Push changes to trigger Amplify build"
echo "   - Your app will be live at the Amplify URL!"
echo ""
echo "📖 For detailed instructions, see DEPLOYMENT.md"
echo ""
print_success "Happy deploying! 🚀"
