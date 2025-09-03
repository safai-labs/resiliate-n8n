#!/bin/bash

# Test script for Resiliate Events n8n node
echo "🚀 Testing Resiliate Events n8n Node Integration"
echo "=============================================="

# n8n instance details
N8N_HOST="192.168.1.161"
N8N_PORT="5678"
N8N_URL="http://${N8N_HOST}:${N8N_PORT}"

echo "📡 Checking n8n connectivity..."
if curl -s -f "${N8N_URL}/healthz" > /dev/null; then
    echo "✅ n8n is accessible at ${N8N_URL}"
else
    echo "❌ n8n is not accessible. Please check if the container is running."
    exit 1
fi

echo ""
echo "🔍 Checking if ResiliateEvents node is loaded..."
echo "To test the node:"
echo "1. Open n8n at: ${N8N_URL}"
echo "2. Create a new workflow"
echo "3. Add a 'Resiliate Events' trigger node"
echo "4. Save and activate the workflow"
echo "5. Copy the webhook URL from the trigger node"
echo "6. Test the webhook with:"
echo ""
echo "   curl -X POST [WEBHOOK_URL] \\"
echo "        -H 'Content-Type: application/json' \\"
echo "        -d '{\"event\": \"test\", \"data\": {\"message\": \"Hello from Resiliate!\"}}'"
echo ""
echo "🌐 Opening n8n in browser..."
echo "Visit: ${N8N_URL}"
echo ""

# Check if we can detect the custom node (this won't work directly, but gives users guidance)
echo "📝 Manual verification steps:"
echo "1. In n8n, click the + button to add a node"
echo "2. Search for 'Resiliate' or look in the 'Trigger' category"
echo "3. You should see 'Resiliate Events' as an available trigger node"
echo ""
echo "If the node is not visible, check docker logs:"
echo "   cd /home/masud/projects/containers/n8n"
echo "   docker compose logs n8n"
echo ""
