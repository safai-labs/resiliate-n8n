# Resiliate n8n Node Development Workflow

This document outlines the development workflow for the Resiliate Events n8n node, supporting development on macOS with deployment to an Ubuntu n8n server.

## Overview

- **Development Environment**: macOS (your local machine)
- **Production Environment**: Ubuntu server with dockerized n8n at `192.168.1.161:5678`
- **Version Control**: GitHub repository with `main` and `next` branches
- **Deployment**: Automated scripts for building and deploying to n8n

## Initial Setup on macOS

### Prerequisites

Ensure you have the following installed on your macOS machine:
- Node.js (v16 or later)
- npm or yarn
- Git
- TypeScript (`npm install -g typescript`)

### Clone the Repository

```bash
# Clone the repository
git clone git@github.com:safai-labs/resiliate-n8n.git resiliate-n8n

# Navigate to the project directory
cd resiliate-n8n

# Switch to the development branch
git checkout next

# Install dependencies
npm install
```

## Development Workflow

### 1. Local Development on macOS

```bash
# Make your changes to the TypeScript files in:
# - nodes/ResiliateEvents/ResiliateEvents.node.ts
# - credentials/ResiliateEventsApi.credentials.ts

# Test compilation locally
npm run build

# Optional: Run linting
npm run lint
```

### 2. Commit and Push Changes

```bash
# Add your changes
git add .

# Commit with descriptive message
git commit -m "feat: your feature description"

# Push to the next branch
git push origin next
```

### 3. Deploy to n8n Server

On the Ubuntu server (`192.168.1.161`), run the auto-deployment script:

```bash
# Navigate to the project directory
cd /home/masud/projects/saf.ai/resiliate/n8n

# Pull latest changes and deploy
./auto_deploy_from_git.sh
```

This script will:
- Pull the latest changes from the `next` branch
- Build the TypeScript
- Deploy to the dockerized n8n instance
- Restart n8n to load the new version

## File Structure

```
resiliate-n8n/
├── nodes/
│   └── ResiliateEvents/
│       └── ResiliateEvents.node.ts        # Main trigger node
├── credentials/
│   └── ResiliateEventsApi.credentials.ts  # API credentials
├── package.json                           # Project configuration
├── tsconfig.json                         # TypeScript configuration
├── deploy_to_n8n.sh                     # Manual deployment script
├── test_resiliate_webhook.sh            # Testing script
├── auto_deploy_from_git.sh              # Auto-deployment from git
└── DEVELOPMENT_WORKFLOW.md              # This document
```

## Testing Your Changes

### 1. On n8n Server

After deployment, test the node:

```bash
# Run the test script
./test_resiliate_webhook.sh
```

### 2. In n8n UI

1. Open http://192.168.1.161:5678 in your browser
2. Create a new workflow
3. Add the "Resiliate Events" trigger node
4. Save and activate the workflow
5. Test the webhook endpoint

### 3. Manual Webhook Testing

```bash
# Replace [WEBHOOK_URL] with the actual webhook URL from n8n
curl -X POST [WEBHOOK_URL] \
     -H 'Content-Type: application/json' \
     -d '{"event": "test", "data": {"message": "Hello from Resiliate!"}}'
```

## Branch Strategy

- **`main`**: Production-ready code
- **`next`**: Development branch for new features
- **feature branches**: For specific features (merge to `next`)

## Troubleshooting

### Common Issues

1. **Node not appearing in n8n**: Check container logs with `docker compose logs n8n`
2. **Build failures**: Ensure TypeScript compiles locally first with `npm run build`
3. **Deployment issues**: Verify file permissions and docker container access

### Logs and Debugging

```bash
# Check n8n container logs
cd /home/masud/projects/containers/n8n
docker compose logs n8n

# Check deployed files
ls -la /home/masud/projects/containers/n8n/n8n_data/nodes/n8n-nodes-resiliate-events/
```

## Quick Reference Commands

### On macOS (Development)
```bash
# Build locally
npm run build

# Commit and push
git add . && git commit -m "your message" && git push origin next
```

### On Ubuntu Server (Deployment)
```bash
# Auto-deploy latest changes
./auto_deploy_from_git.sh

# Manual deployment
./deploy_to_n8n.sh

# Test deployment
./test_resiliate_webhook.sh
```
