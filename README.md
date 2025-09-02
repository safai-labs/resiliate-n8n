# Resiliate Events n8n Node

A custom n8n trigger node for receiving and processing Resiliate events via webhooks.

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

This project provides a **ResiliateEvents** trigger node for n8n that:
- ✅ Receives webhook events via HTTP POST
- ✅ Processes JSON payloads
- ✅ Forwards event data to n8n workflows
- ✅ Supports development on macOS with deployment to Ubuntu

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
│       └── ResiliateEvents.node.ts        # Main trigger node implementation
├── credentials/
│   └── ResiliateEventsApi.credentials.ts  # API credentials (optional)
├── scripts/
│   ├── deploy_to_n8n.sh                   # Manual deployment
│   ├── auto_deploy_from_git.sh           # Git-based auto-deployment
│   └── test_resiliate_webhook.sh         # Testing and verification
├── docs/
│   ├── DEVELOPMENT_WORKFLOW.md           # Complete development guide
│   └── MACOS_SETUP.md                   # macOS setup instructions
├── package.json                         # Project configuration
├── tsconfig.json                        # TypeScript configuration
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

### 2. Test Webhook Endpoint
```bash
# Get webhook URL from n8n UI, then test:
curl -X POST [WEBHOOK_URL] \
     -H 'Content-Type: application/json' \
     -d '{"event": "test", "data": {"message": "Hello from Resiliate!"}}'
```

## 📚 Documentation

- **[DEVELOPMENT_WORKFLOW.md](DEVELOPMENT_WORKFLOW.md)** - Complete development workflow guide
- **[MACOS_SETUP.md](MACOS_SETUP.md)** - macOS environment setup instructions

## 🌟 Features

### ResiliateEvents Trigger Node
- **Webhook-based**: Receives HTTP POST requests
- **JSON Processing**: Handles structured event data
- **Workflow Integration**: Seamlessly forwards data to n8n workflows
- **Modern n8n API**: Built with latest n8n node development standards

### Development Features
- **TypeScript**: Full type safety and modern JavaScript features
- **Hot Reload**: Watch mode for rapid development
- **Automated Deployment**: One-command deployment from git
- **Cross-platform**: Develop on macOS, deploy on Ubuntu

## 🔧 Configuration

### n8n Server
- **URL**: http://192.168.1.161:5678
- **Environment**: Docker Compose with PostgreSQL
- **Custom Nodes Path**: `/home/node/.n8n/nodes/`

### Git Branches
- **`main`**: Production-ready releases
- **`next`**: Development branch (default for development)
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

**Happy coding! 🎉**
