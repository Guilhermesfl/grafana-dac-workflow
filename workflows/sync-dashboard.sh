#!/bin/bash
# Workflow: Sync a dashboard from Grafana to local JSON file
# Usage: ./workflows/sync-dashboard.sh <dashboard-uid> <output-name>

set -e

DASHBOARD_UID=$1
OUTPUT_NAME=$2

if [ -z "$DASHBOARD_UID" ] || [ -z "$OUTPUT_NAME" ]; then
    echo "Usage: $0 <dashboard-uid> <o
    utput-name>"
    echo "Example: $0 abc123def my-dashboard"
    exit 1
fi

echo "📥 Fetching dashboard $DASHBOARD_UID from Grafana..."
# This would be executed via MCP in VS Code Copilot Chat
# For now, we document the workflow

echo "Workflow steps:"
echo "1. Extract dashboard: @grafana get dashboard $DASHBOARD_UID"
echo "2. Save to: dashboards/${OUTPUT_NAME}.json"
echo "3. Copy to provisioning: cp dashboards/${OUTPUT_NAME}.json provisioning/dashboards/"
echo "4. Restart Grafana: docker-compose restart grafana"
echo ""
echo "🤖 Run this in Copilot Chat:"
echo "@grafana get dashboard $DASHBOARD_UID and save it to dashboards/${OUTPUT_NAME}.json"
