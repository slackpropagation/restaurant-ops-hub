# 🚀 AWS Deployment Guide - Restaurant Ops Hub

This guide will help you deploy the Restaurant Ops Hub to AWS using App Runner, Amplify, and RDS.

## 📋 Prerequisites

1. **AWS CLI** installed and configured
2. **Docker** installed
3. **Node.js** and **npm** installed
4. **Git** repository access

## 🏗️ Infrastructure Setup

### Step 1: Deploy AWS Infrastructure

```bash
# Deploy the CloudFormation stack
aws cloudformation create-stack \
  --stack-name restaurant-ops-hub \
  --template-body file://aws-infrastructure.yaml \
  --parameters ParameterKey=DatabasePassword,ParameterValue=YourSecurePassword123! \
  --capabilities CAPABILITY_IAM

# Wait for stack creation (5-10 minutes)
aws cloudformation wait stack-create-complete --stack-name restaurant-ops-hub
```

### Step 2: Get Infrastructure Outputs

```bash
# Get database endpoint
aws cloudformation describe-stacks \
  --stack-name restaurant-ops-hub \
  --query 'Stacks[0].Outputs[?OutputKey==`DatabaseEndpoint`].OutputValue' \
  --output text

# Get ECR repository URI
aws cloudformation describe-stacks \
  --stack-name restaurant-ops-hub \
  --query 'Stacks[0].Outputs[?OutputKey==`ECRRepositoryURI`].OutputValue' \
  --output text
```

## 🐳 Backend Deployment (App Runner)

### Step 3: Build and Push Docker Image

```bash
# Make deployment script executable
chmod +x deploy-aws.sh

# Run deployment script
./deploy-aws.sh
```

### Step 4: Create App Runner Service

1. Go to [AWS App Runner Console](https://console.aws.amazon.com/apprunner/)
2. Click "Create service"
3. Choose "Container registry" as source
4. Select your ECR repository: `restaurant-ops-hub`
5. Configure service:
   - **Service name**: `restaurant-ops-api`
   - **Virtual CPU**: 0.25 vCPU
   - **Virtual memory**: 0.5 GB
   - **Port**: 8000
6. Add environment variables:
   - `DATABASE_URL`: `postgresql://restaurantops:YourPassword@your-db-endpoint:5432/restaurant_ops`
   - `PYTHONPATH`: `/app`
   - `ENVIRONMENT`: `production`
7. Click "Create & deploy"

## ⚛️ Frontend Deployment (Amplify)

### Step 5: Deploy Frontend

1. Go to [AWS Amplify Console](https://console.aws.amazon.com/amplify/)
2. Click "New app" → "Host web app"
3. Connect your Git repository
4. Select branch: `master`
5. Build settings will use `amplify.yml`
6. Add environment variables:
   - `VITE_API_URL`: Your App Runner service URL
7. Click "Save and deploy"

## 🗄️ Database Setup

### Step 6: Initialize Database

```bash
# Connect to your RDS instance
psql -h your-db-endpoint -U restaurantops -d restaurant_ops

# Run the migration
\i infra/db/migrations/versions/001_initial_migration.py

# Seed the database
\i infra/db/expanded_seed.sql
```

## 🔧 Configuration

### Environment Variables

**Backend (App Runner):**
- `DATABASE_URL`: PostgreSQL connection string
- `PYTHONPATH`: `/app`
- `ENVIRONMENT`: `production`
- `CORS_ORIGINS`: Your Amplify app URL

**Frontend (Amplify):**
- `VITE_API_URL`: Your App Runner service URL

## 🌐 Access Your Application

1. **Frontend**: Your Amplify app URL (e.g., `https://main.d1234567890.amplifyapp.com`)
2. **Backend API**: Your App Runner service URL (e.g., `https://abc123.us-east-1.awsapprunner.com`)

## 🔍 Monitoring and Logs

- **App Runner Logs**: CloudWatch Logs
- **Amplify Logs**: Amplify Console → App → Build history
- **Database**: RDS Console → Monitoring

## 💰 Cost Estimation

- **RDS (db.t3.micro)**: ~$15/month
- **App Runner (0.25 vCPU, 0.5GB)**: ~$7/month
- **Amplify**: Free tier (1GB bandwidth)
- **ECR**: ~$1/month
- **Total**: ~$23/month

## 🚨 Troubleshooting

### Common Issues

1. **Database Connection Failed**
   - Check security groups
   - Verify database endpoint
   - Confirm password

2. **CORS Errors**
   - Update `CORS_ORIGINS` in App Runner
   - Check frontend `VITE_API_URL`

3. **Build Failures**
   - Check Amplify build logs
   - Verify `amplify.yml` configuration

### Support

- Check CloudWatch logs for detailed error messages
- Verify all environment variables are set correctly
- Ensure all AWS services are in the same region

## 🔄 Updates and Maintenance

### Updating the Application

1. **Backend**: Push new code → Docker rebuilds automatically
2. **Frontend**: Push to Git → Amplify rebuilds automatically
3. **Database**: Use Alembic migrations

### Scaling

- **App Runner**: Auto-scales based on traffic
- **RDS**: Upgrade instance class as needed
- **Amplify**: Handles frontend scaling automatically

---

🎉 **Congratulations!** Your Restaurant Ops Hub is now live on AWS!
