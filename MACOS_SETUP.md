# macOS Setup Instructions

Quick setup guide for developing Resiliate n8n nodes on your macOS machine.

## Prerequisites Check

Run these commands to verify you have the required tools:

```bash
# Check Node.js (should be v16+)
node --version

# Check npm
npm --version

# Check TypeScript (install if missing)
tsc --version || npm install -g typescript

# Check git
git --version
```

## One-Line Setup

Copy and paste this command to clone and set up the project:

```bash
git clone git@github.com:safai-labs/resiliate-n8n.git resiliate-n8n && cd resiliate-n8n && git checkout next && npm install && echo "✅ Setup complete! You can now start developing."
```

## Manual Setup Steps

If you prefer step-by-step:

```bash
# 1. Clone the repository
git clone git@github.com:safai-labs/resiliate-n8n.git resiliate-n8n

# 2. Navigate to project
cd resiliate-n8n

# 3. Switch to development branch
git checkout next

# 4. Install dependencies
npm install

# 5. Test build
npm run build
```

## Verify Setup

```bash
# Should compile without errors
npm run build

# Should show the compiled files
ls -la dist/

# Should show git status
git status
```

## Start Developing

Now you can edit the TypeScript files and follow the workflow in `DEVELOPMENT_WORKFLOW.md`:

- **Main node**: `nodes/ResiliateEvents/ResiliateEvents.node.ts`
- **Credentials**: `credentials/ResiliateEventsApi.credentials.ts`

## Quick Development Commands

```bash
# Build locally
npm run build

# Watch mode (rebuilds on file changes)
npm run dev

# Commit and push changes
git add . && git commit -m "feat: your description" && git push origin next
```

## Next Steps

1. Make your changes locally
2. Test compilation with `npm run build`
3. Commit and push to the `next` branch
4. Run the auto-deployment script on the Ubuntu server

See `DEVELOPMENT_WORKFLOW.md` for the complete workflow documentation.
