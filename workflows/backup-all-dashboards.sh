#!/bin/bash
# Workflow: Backup all dashboards from Grafana
# Usage: ./workflows/backup-all-dashboards.sh

set -e

BACKUP_DIR="dashboards/backup-$(date +%Y%m%d-%H%M%S)"

echo "📥 Backing up all dashboards to: $BACKUP_DIR"
echo ""
echo "Workflow steps:"
echo "1. List all dashboards: @grafana search dashboards"
echo "2. For each dashboard, extract JSON to $BACKUP_DIR"
echo ""
echo "🤖 Run this in Copilot Chat:"
echo "@grafana search dashboards and save each dashboard JSON to $BACKUP_DIR/<dashboard-name>.json"
