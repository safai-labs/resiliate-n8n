# Resiliate Events n8n Node

A foundational n8n trigger node project for receiving Resiliate™ events via webhooks. **Version 0.1.0 is a basic setup providing core infrastructure and development workflow.**

**Author:** Ahmed Masud <ahmed.masud@saf.ai>  
**Homepage:** https://saf.ai/resiliate/n8n/  
**Documentation:** https://docs.saf.ai/  
**Repository:** https://github.com/safai-labs/resiliate-n8n
git clone git@github.com:safai-labs/resiliate-n8n.git resiliate-n8n && cd resiliate-n8n && git checkout next && npm install

# Start developing
npm run build  # Test compilation
```

### For Ubuntu Server Deployment

```bash
# Navigate to project directory
cd /home/masud/projects/saf.ai/resiliate/n8n

# Auto-deploy latest changes from git
./auto_deploy_from_git.sh
```

## 📋 Overview

This project provides the **foundational infrastructure** for a ResiliateEvents trigger node in n8n.

### ⚠️ **Current Status - Version 0.1.0**

**What's Included (Core Setup):**
- ✅ Basic n8n trigger node framework
- ✅ TypeScript development environment  
- ✅ Cross-platform development workflow (macOS → Ubuntu)
- ✅ Automated deployment scripts
- ✅ Docker integration with existing n8n instance
- ✅ Custom ninja icon integration
- ✅ Git Flow version control setup
- ✅ Comprehensive documentation and guides

**What's NOT Implemented Yet:**
- ❌ **Event Processing Logic**: Basic webhook receiver only, no event-specific processing
- ❌ **Resiliate API Integration**: No actual connection to Resiliate services
- ❌ **Advanced Filtering**: No event filtering or routing logic
- ❌ **Error Handling**: Minimal error handling and retry mechanisms
- ❌ **Authentication**: No API authentication or security features
- ❌ **Event Transformation**: No data transformation or enrichment
- ❌ **Monitoring/Logging**: No advanced monitoring or logging features

**Current Functionality:**
- Receives HTTP POST webhooks
- Forwards raw JSON payload to n8n workflows
- Basic webhook endpoint functionality

## 🏗️ Architecture

- **Development Environment**: macOS with TypeScript
- **Production Environment**: Ubuntu server with dockerized n8n
- **Version Control**: Git flow with `main` and `next` branches
- **Deployment**: Automated scripts for CI/CD workflow

## 📁 Project Structure

```
resiliate-n8n/
├── nodes/
│   └── ResiliateEvents/
│       ├── ResiliateEvents.node.ts        # Basic trigger node implementation
│       └── ninja-icon.png                 # Custom ninja icon
├── credentials/
│   └── ResiliateEventsApi.credentials.ts  # Placeholder credentials
├── scripts/
│   ├── deploy_to_n8n.sh                   # Manual deployment
│   ├── auto_deploy_from_git.sh           # Git-based auto-deployment
│   └── test_resiliate_webhook.sh         # Testing and verification
├── assets/                               # Ninja icon assets
