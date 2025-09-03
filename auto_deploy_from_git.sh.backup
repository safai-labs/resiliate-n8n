#!/bin/bash

# Auto-deployment script for Resiliate n8n module from Git
set -e

echo "🚀 Auto-deploying Resiliate Events n8n Node from Git..."
echo "======================================================"

# Configuration
N8N_DIR="/home/masud/projects/containers/n8n"
TARGET_DIR="${N8N_DIR}/n8n_data/nodes/n8n-nodes-resiliate-events"
CURRENT_DIR=$(pwd)

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: Not in a git repository"
    echo "   Please run this script from the resiliate-n8n project directory"
    exit 1
fi

# Get current branch info
CURRENT_BRANCH=$(git branch --show-current)
echo "📍 Current branch: ${CURRENT_BRANCH}"

# Stash any local changes
if ! git diff-index --quiet HEAD --; then
    echo "💾 Stashing local changes..."
    git stash push -m "Auto-stash before deployment $(date)"
fi

# Pull latest changes
echo "📥 Pulling latest changes from origin/${CURRENT_BRANCH}..."
git pull origin "${CURRENT_BRANCH}"

# Check if Node.js and npm are available
if ! command -v npm &> /dev/null; then
    echo "❌ Error: npm is not installed or not in PATH"
    exit 1
fi

# Install dependencies if needed
if [ ! -d "node_modules" ] || [ "package.json" -nt "node_modules" ]; then
    echo "📚 Installing/updating dependencies..."
    npm install
fi

# Build the module
echo "📦 Building TypeScript..."
if ! npm run build; then
    echo "❌ Build failed! Check the errors above."
    exit 1
fi

# Check if build was successful
if [ ! -d "dist" ] || [ ! -f "dist/nodes/ResiliateEvents/ResiliateEvents.node.js" ]; then
    echo "❌ Build output not found! Build may have failed."
    exit 1
fi

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

# Verify files were copied correctly
if [ ! -f "${TARGET_DIR}/dist/nodes/ResiliateEvents/ResiliateEvents.node.js" ]; then
    echo "❌ Deployment files not copied correctly!"
    exit 1
fi

# Check if Docker is running and n8n container exists
cd "${N8N_DIR}"
if ! docker compose ps -q n8n > /dev/null 2>&1; then
    echo "❌ Error: n8n container not found or Docker not running"
    echo "   Please ensure Docker is running and n8n container exists in ${N8N_DIR}"
    cd "${CURRENT_DIR}"
    exit 1
fi

# Reinstall dependencies in the container
echo "📚 Installing dependencies in n8n container..."
if ! docker compose exec n8n sh -c "cd /home/node/.n8n/nodes && npm install"; then
    echo "⚠️  Warning: Failed to install dependencies in container"
    echo "   The deployment files are in place, but you may need to manually restart n8n"
fi

# Restart n8n
echo "🔄 Restarting n8n..."
if ! docker compose restart n8n; then
    echo "❌ Failed to restart n8n container"
    cd "${CURRENT_DIR}"
    exit 1
fi

# Wait a moment for n8n to start
echo "⏳ Waiting for n8n to start..."
sleep 5

# Check if n8n is responding
if curl -s -f "http://192.168.1.161:5678/healthz" > /dev/null; then
    echo "✅ n8n is responding!"
else
    echo "⚠️  Warning: n8n may not be fully started yet. Check manually."
fi

cd "${CURRENT_DIR}"

echo ""
echo "✅ Auto-deployment complete!"
echo ""
echo "🌐 n8n is accessible at: http://192.168.1.161:5678"
echo "📊 Latest commit: $(git log -1 --oneline)"
echo ""
echo "📝 To test the node:"
echo "1. Open n8n in your browser"
echo "2. Create a new workflow"
echo "3. Add a 'Resiliate Events' trigger node"
echo "4. Activate the workflow and test the webhook"
echo ""
echo "🔍 To check logs: cd ${N8N_DIR} && docker compose logs n8n"
echo ""

