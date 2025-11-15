# Grafana MCP Dashboard Versioning Workflow

A demonstration of dashboard-as-code using Grafana Model Context Protocol (MCP) to version control and programmatically manage Grafana dashboards.

## Why Dashboard-as-Code?

Dashboard-as-Code offers several advantages over traditional UI-based dashboard management:

- **Multi-environment consistency**: Deploy identical dashboards across dev, staging, and production
- **Team collaboration**: Review dashboard changes through Pull Requests
- **Audit trails**: Track who changed what and when using Git history
- **Automated testing**: Validate dashboard configurations before deployment
- **Disaster recovery**: Restore dashboards quickly from version control
- **CI/CD integration**: Automate dashboard deployments as part of your pipeline

This approach complements RBAC and backups—use provisioning for standardized dashboards and UI editing for exploratory or personal ones.

## Prerequisites

- Docker and Docker Compose installed
- VS Code (version 1.102 or later) with GitHub Copilot
- Git

## Project Structure

```
grafana-mcp-workflow/
├── docker-compose.yml              # Stack definition
├── prometheus.yml                  # Prometheus configuration
├── provisioning/
│   ├── dashboards/
│   │   └── dashboard.yml          # Dashboard provisioning config
│   └── datasources/
│       └── prometheus.yml         # Prometheus datasource config
├── .vscode/
│   └── mcp.json                   # MCP server configuration
├── dashboards/
│   └── node-exporter.json         # Versioned dashboard JSON (created later)
├── .env.example                   # Environment variable template
├── .gitignore
└── README.md
```

## Setup Instructions

### Step 1: Start the Monitoring Stack

Start Grafana, Prometheus, and Node Exporter:

```bash
docker-compose up -d
```

Verify all services are running:

```bash
docker-compose ps
```

You should see three containers running:
- `grafana` on port 3000
- `prometheus` on port 9090
- `node-exporter` on port 9100

### Step 2: Access Grafana and Configure

1. Open Grafana at http://localhost:3000
2. Login with default credentials:
   - Username: `admin`
   - Password: `admin`
   - (You'll be prompted to change the password)

3. Verify Prometheus datasource is configured:
   - Go to **Configuration** → **Data Sources**
   - You should see "Prometheus" already configured (auto-provisioned)

**📸 Screenshot placeholder**: Grafana login and datasource verification

### Step 3: Import Node Exporter Dashboard

1. In Grafana, click **Dashboards** → **Import**
2. Enter dashboard ID: `1860` (Node Exporter Full)
3. Click **Load**
4. Select the **Prometheus** datasource
5. Click **Import**

You should now see a fully populated Node Exporter dashboard with system metrics.

**📸 Screenshot placeholder**: Dashboard import process and final dashboard view

### Step 4: Create Service Account and API Token

1. Go to **Administration** → **Service Accounts**
2. Click **Add service account**
   - Name: `MCP Client`
   - Role: `Editor`
3. Click **Add service account token**
   - Name: `mcp-token`
   - Copy the generated token immediately (you won't see it again)

4. Create a `.env` file from the template:

```bash
cp .env.example .env
```

5. Edit `.env` and paste your API token:

```
GRAFANA_URL=http://localhost:3000
GRAFANA_API_TOKEN=your_actual_token_here
```

**📸 Screenshot placeholder**: Service account creation and token generation

### Step 5: Install and Configure Grafana MCP

The Grafana MCP server runs via Docker and provides programmatic access to your Grafana instance.

**Create workspace MCP configuration:**

1. Create `.vscode/mcp.json` in your project root:

```json
{
	"servers": {
		"grafana": {
			"command": "docker",
			"args": [
				"run",
				"--rm",
				"-i",
				"-e",
				"GRAFANA_URL",
				"-e",
				"GRAFANA_SERVICE_ACCOUNT_TOKEN",
				"mcp/grafana",
				"-t",
				"stdio",
				"-debug"
			],
			"env": {
				"GRAFANA_URL": "http://host.docker.internal:3000",
				"GRAFANA_SERVICE_ACCOUNT_TOKEN": "your_service_account_token_here",
				"GRAFANA_ORG_ID": "1"
			}
		}
	},
	"inputs": []
}
```

2. Replace `your_service_account_token_here` with the token you created in Step 4

3. **Important for macOS/Windows**: Use `http://host.docker.internal:3000` as the GRAFANA_URL (not `localhost`) so the Docker container can reach your host machine

4. Ensure MCP support is enabled in VS Code settings:
   - Open Command Palette: `Cmd/Ctrl + Shift + P`
   - Run: `Preferences: Open User Settings (JSON)`
   - Add or verify: `"chat.mcp.access": "all"`

5. Restart VS Code to load the MCP server

**📸 Screenshot placeholder**: VS Code MCP configuration in .vscode/mcp.json

### Step 6: Extract Dashboard JSON via MCP

1. Open GitHub Copilot Chat in VS Code Insiders
2. Use MCP to list dashboards:
   ```
   @grafana list all dashboards
   ```
3. Find the "Node Exporter Full" dashboard and note its UID
4. Extract the dashboard JSON:
   ```
   @grafana get dashboard <dashboard-uid> and save it to dashboards/node-exporter.json
   ```

You should now have the dashboard JSON file in your repository.

**📸 Screenshot placeholder**: MCP chat extracting dashboard JSON

### Step 7: Modify and Update Dashboard

1. Edit `dashboards/node-exporter.json`:
   - Change the `title` field (e.g., "Node Exporter Full - Custom")
   - Modify the `description` field
   - Optionally modify panel titles or add new panels

2. Use MCP to update the dashboard in Grafana:
   ```
   @grafana update dashboard from dashboards/node-exporter.json
   ```

3. Verify changes in Grafana UI at http://localhost:3000

4. Commit changes to Git:
   ```bash
   git add dashboards/node-exporter.json
   git commit -m "feat: customize node exporter dashboard title and description"
   ```

**📸 Screenshot placeholder**: Git diff showing dashboard changes and updated Grafana UI

### Step 8: Deploy Dashboard via Provisioning

Now we'll demonstrate how the versioned dashboard automatically provisions on Grafana startup.

1. Copy the dashboard JSON to the provisioning directory:
   ```bash
   cp dashboards/node-exporter.json provisioning/dashboards/
   ```

2. The `docker-compose.yml` already mounts the provisioning directory to Grafana

3. Restart Grafana to apply provisioning:
   ```bash
   docker-compose restart grafana
   ```

4. Access Grafana at http://localhost:3000
5. Navigate to **Dashboards** - you should see your dashboard automatically loaded
6. Notice the dashboard is marked as provisioned (cannot be deleted via UI)

**📸 Screenshot placeholder**: Provisioned dashboard with "provisioned" indicator

### Step 9: Test the Complete Workflow

To demonstrate the full GitOps workflow:

1. Make another change to `dashboards/node-exporter.json`
2. Commit to Git
3. Restart Grafana:
   ```bash
   docker-compose restart grafana
   ```
4. Verify changes are automatically applied

## Cleanup

To stop and remove all containers:

```bash
docker-compose down
```

To also remove volumes (delete all data):

```bash
docker-compose down -v
```

## Key Takeaways

1. **Versioning**: Dashboard JSON in Git provides complete history and rollback capability
2. **Reproducibility**: Anyone can spin up identical dashboards using this repository
3. **Collaboration**: Changes can be reviewed via Pull Requests before deployment
4. **Automation**: Dashboards deploy automatically via provisioning, enabling CI/CD
5. **MCP Power**: The Model Context Protocol provides programmatic dashboard management directly from your IDE

## Next Steps for Production

While this demonstrates the development workflow, production deployments should consider:

- Persistent storage configuration with named volumes
- Secrets management (avoid API keys in env vars)
- RBAC setup with proper roles and permissions
- Backup strategy for Grafana database
- Monitoring the monitoring stack itself
- CI/CD pipeline for dashboard validation and deployment

## License

MIT

## Resources

- [Grafana MCP Server](https://github.com/grafana/mcp-grafana)
- [Grafana Provisioning Documentation](https://grafana.com/docs/grafana/latest/administration/provisioning/)
- [Model Context Protocol](https://modelcontextprotocol.io/)
- [Node Exporter Full Dashboard](https://grafana.com/grafana/dashboards/1860)
