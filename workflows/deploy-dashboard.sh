#!/bin/bash
# Workflow: Deploy a local dashboard JSON to Grafana
# Usage: ./workflows/deploy-dashboard.sh <dashboard-name>

set -e

DASHBOARD_NAME=$1

if [ -z "$DASHBOARD_NAME" ]; then
    echo "Usage: $0 <dashboard-name>"
    echo "Example: $0 my-dashboard"
    exit 1
fi

DASHBOARD_FILE="dashboards/${DASHBOARD_NAME}.json"

if [ ! -f "$DASHBOARD_FILE" ]; then
    echo "❌ Error: Dashboard file not found: $DASHBOARD_FILE"
    exit 1
fi

echo "📤 Deploying dashboard: $DASHBOARD_FILE"
echo ""
echo "Workflow steps:"
echo "1. Update dashboard in Grafana via MCP"
echo "2. Copy to provisioning folder"
echo "3. Restart Grafana"
echo ""
echo "🤖 Run this in Copilot Chat:"
echo "@grafana update dashboard from $DASHBOARD_FILE"
echo ""
echo "Then run:"
echo "cp $DASHBOARD_FILE provisioning/dashboards/"
echo "docker-compose restart grafana"
