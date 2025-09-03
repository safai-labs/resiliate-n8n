# Resiliate Events n8n Node

A foundational n8n trigger node project for receiving Resiliate events via webhooks. **Version 0.1.0 is a basic setup providing core infrastructure and development workflow.**

## 🚀 Quick Start

### For macOS Development

```bash
# Clone and setup (one command)
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
├── docs/
│   ├── DEVELOPMENT_WORKFLOW.md           # Complete development guide
│   └── MACOS_SETUP.md                   # macOS setup instructions
├── package.json                         # Project configuration
├── tsconfig.json                        # TypeScript configuration
├── CHANGELOG.md                         # Version history
└── README.md                           # This file
```

## 🔄 Development Workflow

### 1. Setup (One-time)

**On macOS:**
```bash
git clone git@github.com:safai-labs/resiliate-n8n.git resiliate-n8n
cd resiliate-n8n
git checkout next
npm install
```

### 2. Development Loop

**On macOS:**
```bash
# Edit TypeScript files
# - nodes/ResiliateEvents/ResiliateEvents.node.ts
# - credentials/ResiliateEventsApi.credentials.ts

# Test compilation
npm run build

# Commit and push
git add .
git commit -m "feat: your changes"
git push origin next
```

### 3. Deployment

**On Ubuntu Server:**
```bash
cd /home/masud/projects/saf.ai/resiliate/n8n
./auto_deploy_from_git.sh
```

### 4. Testing

**In n8n UI (http://192.168.1.161:5678):**
1. Create new workflow
2. Add "Resiliate Events" trigger node
3. Save and activate workflow
4. Test webhook endpoint

## 🛠️ Available Scripts

| Script | Purpose | Environment |
|--------|---------|-------------|
| `npm run build` | Compile TypeScript | macOS/Ubuntu |
| `npm run dev` | Watch mode compilation | macOS |
| `./deploy_to_n8n.sh` | Manual deployment | Ubuntu |
| `./auto_deploy_from_git.sh` | Git-based deployment | Ubuntu |
| `./test_resiliate_webhook.sh` | Test connectivity | Ubuntu |

## 🧪 Testing Your Node

### 1. Verify Node Availability
1. Open http://192.168.1.161:5678
2. Create new workflow
3. Search for "Resiliate Events" in node picker
4. Add the trigger node to your workflow

### 2. Test Basic Webhook Functionality
```bash
# Get webhook URL from n8n UI, then test:
curl -X POST [WEBHOOK_URL] \
     -H 'Content-Type: application/json' \
     -d '{"event": "test", "data": {"message": "Hello from Resiliate!"}}'
```

**Expected Result:** Raw JSON payload forwarded to n8n workflow (no processing applied).

## 📚 Documentation

- **[DEVELOPMENT_WORKFLOW.md](DEVELOPMENT_WORKFLOW.md)** - Complete development workflow guide
- **[MACOS_SETUP.md](MACOS_SETUP.md)** - macOS environment setup instructions
- **[CHANGELOG.md](CHANGELOG.md)** - Version history and release notes

## 🌟 Version 0.1.0 - Core Infrastructure

### What This Release Provides
- **🏗️ Development Framework**: Complete TypeScript project setup
- **🔄 Deployment Pipeline**: Automated cross-platform deployment
- **🐳 Docker Integration**: Seamless container deployment
- **🥷 Visual Identity**: Custom ninja icon integration
- **📖 Documentation**: Comprehensive development guides
- **🔀 Version Control**: Git Flow workflow implementation

### What This Release Does NOT Provide
- **No Business Logic**: Basic webhook receiver only
- **No Resiliate Integration**: Placeholder for future API connections
- **No Advanced Features**: Event processing, filtering, authentication, etc.

## 🔧 Configuration

### n8n Server
- **URL**: http://192.168.1.161:5678
- **Environment**: Docker Compose with PostgreSQL
- **Custom Nodes Path**: `/home/node/.n8n/nodes/`

### Git Branches
- **`main`**: Production-ready releases (currently v0.1.0)
- **`next`**: Development branch for v0.2.0+ features
- **Feature branches**: Merge to `next` via PR

## 🚨 Troubleshooting

### Common Issues

**Node not appearing in n8n:**
```bash
# Check container logs
cd /home/masud/projects/containers/n8n
docker compose logs n8n
```

**Build failures:**
```bash
# Test local compilation first
npm run build
# Check TypeScript errors in output
```

**Deployment issues:**
```bash
# Verify deployment files
ls -la /home/masud/projects/containers/n8n/n8n_data/nodes/n8n-nodes-resiliate-events/
```

### Debug Commands
```bash
# Check n8n container status
docker compose ps

# View recent logs
docker compose logs n8n --tail 50

# Test webhook connectivity
curl -s -f http://192.168.1.161:5678/healthz
```

## 🗺️ Roadmap

### Version 0.2.0 (Planned)
- Resiliate API integration
- Event authentication and validation
- Basic event processing and transformation
- Error handling and retry logic

### Version 0.3.0 (Planned) 
- Advanced event filtering and routing
- Enhanced monitoring and logging
- Performance optimizations
- Extended documentation

### Future Versions
- Advanced Resiliate service integrations
- Event enrichment and correlation
- Scalability improvements
- Enterprise features

## 🤝 Contributing

1. Fork the repository
2. Create feature branch from `next`
3. Make your changes
4. Test locally with `npm run build`
5. Submit pull request to `next` branch

## 📄 License

MIT License - see LICENSE file for details

## 🆘 Support

For issues or questions:
1. Check the troubleshooting section above
2. Review logs with the debug commands
3. Consult the detailed workflow documentation
4. Open an issue on GitHub

---

**Version 0.1.0**: Core infrastructure and development workflow foundation. Ready for feature development in v0.2.0+ 🎉🥷
