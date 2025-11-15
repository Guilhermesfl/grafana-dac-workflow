# Grafana Dashboard Workflows

This directory contains reusable workflows for managing Grafana dashboards as code.

## Available Workflows

### 1. Sync Dashboard from Grafana
**Script:** `sync-dashboard.sh`

Extract a dashboard from Grafana and save it locally.

**Usage:**
```bash
./workflows/sync-dashboard.sh <dashboard-uid> <output-name>
```

**Example:**
```bash
./workflows/sync-dashboard.sh abc123def node-exporter-full
```

**Copilot Command:**
```
@grafana get dashboard abc123def and save it to dashboards/node-exporter-full.json
```

---

### 2. Deploy Dashboard to Grafana
**Script:** `deploy-dashboard.sh`

Update a dashboard in Grafana from a local JSON file.

**Usage:**
```bash
./workflows/deploy-dashboard.sh <dashboard-name>
```

**Example:**
```bash
./workflows/deploy-dashboard.sh node-exporter-full
```

**Copilot Command:**
```
@grafana update dashboard from dashboards/node-exporter-full.json
```

---

### 3. Backup All Dashboards
**Script:** `backup-all-dashboards.sh`

Create a timestamped backup of all dashboards.

**Usage:**
```bash
./workflows/backup-all-dashboards.sh
```

**Copilot Command:**
```
@grafana search dashboards and save each dashboard JSON to dashboards/backup-<timestamp>/<dashboard-name>.json
```

---

## Custom Workflow Prompts

You can use these prompts directly in VS Code Copilot Chat:

### Complete Dashboard Sync Workflow
```
@grafana I need to sync dashboard <uid>:
1. Get the dashboard JSON
2. Save it to dashboards/<name>.json
3. Copy it to provisioning/dashboards/
4. Show me the docker-compose restart command
```

### Dashboard Promotion Workflow
```
@grafana I want to promote dashboard <name> from dev to prod:
1. Read dashboards/<name>.json
2. Update the datasource UID to production
3. Update the dashboard in Grafana
4. Commit the changes to git
```

### Audit Workflow
```
@grafana Help me audit my dashboards:
1. List all dashboards in Grafana
2. Compare with files in dashboards/ folder
3. Show me which dashboards are not version controlled
4. Show me which JSON files are not deployed
```

---

## Creating Your Own Workflows

To create a custom workflow:

1. **Identify the steps** - What MCP commands do you need?
2. **Create a script** - Add a new `.sh` file in this folder
3. **Document the Copilot prompts** - Add examples to this README
4. **Test the workflow** - Run it in Copilot Chat

### Example Custom Workflow Template

```bash
#!/bin/bash
# Workflow: [Your workflow name]
# Usage: ./workflows/my-workflow.sh [args]

set -e

echo "🤖 Run this in Copilot Chat:"
echo "@grafana [your MCP commands here]"
```

---

## Tips for Effective Workflows

1. **Be specific**: Include dashboard UIDs, file paths, and exact commands
2. **Chain commands**: Tell Copilot to do multiple steps in sequence
3. **Use variables**: Reference specific files and folders
4. **Verify actions**: Ask Copilot to confirm changes before applying
5. **Document results**: Have Copilot summarize what was done

## Advanced: Using MCP Programmatically

For more complex workflows, you can interact with the Grafana MCP server programmatically:

```typescript
// Example: Node.js script using MCP
import { Client } from '@modelcontextprotocol/sdk/client/index.js';

const client = new Client({
  name: 'grafana-workflow',
  version: '1.0.0'
});

// Connect to your Grafana MCP server
await client.connect(transport);

// Call MCP tools
const result = await client.callTool({
  name: 'mcp_grafana_get_dashboard',
  arguments: { dashboardUid: 'abc123' }
});
```

---

## Related Files

- `../README.md` - Main project documentation
- `../.github/copilot-instructions.md` - Copilot configuration for this project
- `../dashboards/` - Dashboard JSON files
- `../provisioning/` - Grafana provisioning configuration
