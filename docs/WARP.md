# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

This is a custom n8n trigger node called **ResiliateEvents** that receives webhook events and forwards them to n8n workflows. The project follows a cross-platform development pattern: development on macOS with deployment to an Ubuntu server running dockerized n8n.

## Development Commands

### Initial Setup
```bash
# One-line setup from scratch
git clone git@github.com:safai-labs/resiliate-n8n.git resiliate-n8n && cd resiliate-n8n && git checkout next && npm install

# Verify setup
npm run build
```

### Build & Development
```bash
# Build TypeScript (most commonly used)
npm run build

# Watch mode for active development
npm run dev

# Code quality
npm run lint
npm run lint:fix
npm run format
```

### Testing Compilation
```bash
# Test that TypeScript compiles without errors
npm run build

# Verify output structure
ls -la dist/
```

### Git Workflow
```bash
# Standard development flow (always use 'next' branch)
git checkout next
git add .
git commit -m "feat: description"
git push origin next
```

### Deployment Commands (Ubuntu Server)
```bash
# Auto-deploy latest from git (recommended)
./auto_deploy_from_git.sh

# Manual deployment
./deploy_to_n8n.sh

# Test deployment
./test_resiliate_webhook.sh
```

### Debugging & Troubleshooting
```bash
# Check n8n container logs
cd /home/masud/projects/containers/n8n && docker compose logs n8n

# Verify deployed files
ls -la /home/masud/projects/containers/n8n/n8n_data/nodes/n8n-nodes-resiliate-events/

# Test n8n connectivity
curl -s -f http://192.168.1.161:5678/healthz

# Check container status
docker compose ps
```

## Architecture Overview

### Development Environment
- **Local Development**: macOS with TypeScript, Node.js, and npm
- **Production Deployment**: Ubuntu server with Docker Compose running n8n
- **Build Tool**: TypeScript compiler (`tsc`)
- **Package Manager**: npm
- **Version Control**: Git with `main` (production) and `next` (development) branches

### Code Structure
```
resiliate-n8n/
├── nodes/ResiliateEvents/
│   ├── ResiliateEvents.node.ts    # Main trigger node implementation
│   └── resiliate-events.svg       # Custom n8n node icon
├── credentials/
│   └── ResiliateEventsApi.credentials.ts  # API credentials (minimal/optional)
├── scripts/                       # Deployment automation
│   ├── auto_deploy_from_git.sh   # Git-based auto-deployment
│   ├── deploy_to_n8n.sh         # Manual deployment
│   └── test_resiliate_webhook.sh # Testing script
└── dist/                         # TypeScript compilation output
```

### Node Implementation Details
- **Node Type**: Trigger node (starts workflows)
- **Input Method**: HTTP POST webhooks
- **Response Mode**: `onReceived` (immediate response)
- **Data Processing**: Accepts JSON payloads and forwards to n8n workflows
- **n8n API Version**: v1
- **Icon**: Custom SVG icon (`resiliate-events.svg`) with animated event flow indicators

### Custom Icon Design
The ResiliateEvents node includes a custom SVG icon featuring:
- **Lightning Bolt**: Central symbol representing event triggers and real-time processing
- **Animated Indicators**: Pulsing circles showing data flow around the bolt
- **Color Scheme**: Purple/blue gradient background with white lightning bolt
- **Branding**: Subtle "R" for Resiliate in bottom corner
- **Technical**: SVG format for crisp scaling, includes CSS animations for visual appeal

### Deployment Architecture
- **Source**: Git repository with TypeScript source
- **Build**: Compiles TypeScript to JavaScript in `dist/` directory
- **Target**: Docker volume at `/home/node/.n8n/nodes/` in n8n container
- **Installation**: npm package structure with `package.json` and compiled files
- **Activation**: Requires n8n container restart to load new/updated nodes

### Cross-Platform Workflow
1. **Development**: Edit TypeScript files on macOS
2. **Local Testing**: Compile with `npm run build` to verify syntax
3. **Version Control**: Commit/push to `next` branch via Git
4. **Deployment**: Run `auto_deploy_from_git.sh` on Ubuntu server
5. **Server Process**: Script pulls latest code, builds, deploys to Docker volume, restarts n8n
6. **Verification**: Test webhook endpoints in n8n UI at http://192.168.1.161:5678

### Key Configuration Files
- **package.json**: Defines n8n node structure, build scripts, and dependencies
- **tsconfig.json**: TypeScript compilation settings (ES2017, CommonJS modules)
- **auto_deploy_from_git.sh**: Full automation including git pull, build, deploy, and restart

### Testing Strategy
- **Local**: TypeScript compilation verification
- **Deployment**: Automated scripts verify file copying and container restart
- **Integration**: Manual testing via n8n UI and webhook calls using curl
- **Health Checks**: HTTP endpoint monitoring for n8n availability

## Development Notes

### Branch Strategy
- Use `next` branch for all development work
- `main` branch contains production-ready releases
- Always work from and push to `next` branch during development

### Build Requirements
- Node.js v16+
- TypeScript compiler (`npm install -g typescript`)
- All dependencies installed via `npm install`

### Deployment Dependencies
- Docker and Docker Compose on Ubuntu server
- n8n container running with custom nodes directory mounted
- Network access to Ubuntu server at 192.168.1.161:5678

### Important Paths
- **Development**: `/Users/masud/projects/saf.ai/resiliate/n8n` (macOS)
- **Production**: `/home/masud/projects/containers/n8n` (Ubuntu server)
- **n8n Data**: `/home/masud/projects/containers/n8n/n8n_data/nodes/` (Docker volume)
