#!/bin/bash

# Deployment script for Resiliate n8n module
set -e

echo "🔄 Deploying Resiliate Events n8n Node..."
echo "=========================================="

# Configuration
N8N_DIR="/home/masud/projects/containers/n8n"
TARGET_DIR="${N8N_DIR}/n8n_data/nodes/n8n-nodes-resiliate-events"

# Build the module
echo "📦 Building TypeScript..."
npm run build

# Remove old deployment
echo "🗑️  Removing old deployment..."
rm -rf "${TARGET_DIR}"

# Create new deployment structure
echo "📁 Creating deployment structure..."
mkdir -p "${TARGET_DIR}/dist"

# Copy built files and package.json
echo "📋 Copying files..."
cp -r dist/* "${TARGET_DIR}/dist/"
cp package.json "${TARGET_DIR}/"

# Reinstall dependencies in the container
echo "📚 Installing dependencies in n8n container..."
cd "${N8N_DIR}"
docker compose exec n8n sh -c "cd /home/node/.n8n/nodes && npm install"

# Restart n8n
echo "🔄 Restarting n8n..."
docker compose restart n8n

echo ""
echo "✅ Deployment complete!"
echo ""
echo "🌐 n8n is accessible at: http://192.168.1.161:5678"
echo ""
echo "📝 To test the node:"
echo "1. Open n8n in your browser"
echo "2. Create a new workflow"
echo "3. Add a 'Resiliate Events' trigger node"
echo "4. Activate the workflow and test the webhook"
echo ""

