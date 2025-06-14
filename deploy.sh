#!/bin/bash

# AI Video Repurposing - Deployment Script
# This script sets up the n8n backend and prepares the frontend for deployment

set -e

echo "🚀 Starting AI Video Repurposing Deployment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed. Please install Docker first.${NC}"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose is not installed. Please install Docker Compose first.${NC}"
    exit 1
fi

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}📝 Creating .env file from template...${NC}"
    cp env.example .env
    echo -e "${YELLOW}⚠️  Please edit .env file with your configuration before proceeding.${NC}"
    read -p "Press Enter to continue after editing .env..."
fi

# Load environment variables
source .env

# Validate required environment variables
required_vars=("OPENAI_API_KEY" "N8N_USER" "N8N_PASSWORD" "N8N_ENCRYPTION_KEY")
for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        echo -e "${RED}❌ Required environment variable $var is not set in .env file${NC}"
        exit 1
    fi
done

echo -e "${GREEN}✅ Environment variables validated${NC}"

# Create workflows directory
mkdir -p workflows
echo -e "${GREEN}✅ Created workflows directory${NC}"

# Copy the n8n workflow
if [ -f "name_AI_Video_Repurposing_2.json" ]; then
    cp name_AI_Video_Repurposing_2.json workflows/
    echo -e "${GREEN}✅ Copied workflow file${NC}"
fi

# Create SSL directory (for production)
mkdir -p ssl
echo -e "${GREEN}✅ Created SSL directory${NC}"

# Build and start the containers
echo -e "${YELLOW}🏗️  Building Docker containers...${NC}"
docker-compose build

echo -e "${YELLOW}🚀 Starting services...${NC}"
docker-compose up -d

# Wait for n8n to be ready
echo -e "${YELLOW}⏳ Waiting for n8n to start...${NC}"
sleep 30

# Check if n8n is running
if curl -f http://localhost:5678/healthz &> /dev/null; then
    echo -e "${GREEN}✅ n8n is running successfully!${NC}"
else
    echo -e "${RED}❌ n8n failed to start. Check logs with: docker-compose logs n8n${NC}"
    exit 1
fi

# Display access information
echo -e "\n${GREEN}🎉 Deployment completed successfully!${NC}"
echo -e "\n📋 Access Information:"
echo -e "   n8n Interface: http://localhost:5678"
echo -e "   Username: ${N8N_USER}"
echo -e "   Password: ${N8N_PASSWORD}"
echo -e "\n📊 Monitor logs with: docker-compose logs -f"
echo -e "🛑 Stop services with: docker-compose down"

# Frontend deployment instructions
echo -e "\n${YELLOW}📱 Frontend Deployment Instructions:${NC}"
echo -e "1. Navigate to the frontend directory: cd frontend"
echo -e "2. Install dependencies: npm install"
echo -e "3. Configure environment variables in frontend/.env.local:"
echo -e "   NEXT_PUBLIC_N8N_API_URL=https://your-domain.com/api/v1"
echo -e "   NEXT_PUBLIC_WORKFLOW_ID=your-workflow-id"
echo -e "   NEXT_PUBLIC_N8N_API_KEY=your-api-key"
echo -e "4. Build for production: npm run build"
echo -e "5. Deploy to Vercel: npx vercel --prod"
echo -e "\n${GREEN}✨ Happy video repurposing!${NC}" 