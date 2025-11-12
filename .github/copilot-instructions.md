# Copilot Instructions for grafana-dac-workflow

## Project Overview
This repository demonstrates a dashboard-as-code workflow for Grafana using the Model Context Protocol (MCP). It provisions, versions, and manages Grafana dashboards programmatically, supporting GitOps and CI/CD best practices.

## Architecture & Data Flow
- **Docker Compose** orchestrates three main services: Grafana, Prometheus, and Node Exporter.
- **Provisioning**: Dashboards and datasources are auto-provisioned via files in `provisioning/dashboards/` and `provisioning/datasources/`.
- **Dashboard JSON**: Versioned dashboard definitions are stored in `dashboards/` and can be synced with Grafana using MCP.
- **Prometheus** is configured as the default datasource and scrapes metrics from itself and Node Exporter.

## Key Developer Workflows
- **Start stack**: `docker-compose up -d`
- **Stop stack**: `docker-compose down` (add `-v` to remove volumes)
- **Restart Grafana**: `docker-compose restart grafana`
- **Provision dashboards**: Place JSON files in `provisioning/dashboards/` and restart Grafana
- **Extract/update dashboards**: Use MCP via VS Code Copilot Chat (see README for commands)
- **Environment setup**: Copy `.env.example` to `.env` and set your Grafana API token

## Project-Specific Conventions
- **Dashboard-as-code**: All dashboard changes should be made to JSON files in `dashboards/` and committed to Git
- **Provisioning**: Only dashboards in `provisioning/dashboards/` are auto-loaded on Grafana startup
- **Datasource config**: Managed in `provisioning/datasources/prometheus.yml`
- **No secrets in repo**: Use `.env` for sensitive values; never commit `.env` files
- **MCP usage**: Interact with Grafana programmatically using MCP commands in VS Code Copilot Chat

## Integration Points
- **Grafana MCP**: Requires VS Code Insiders and MCP server (`@grafana/mcp-server-grafana`)
- **Prometheus**: Configured via `prometheus.yml` and auto-provisioned in Grafana
- **Node Exporter**: Provides system metrics, scraped by Prometheus

## Examples
- To extract a dashboard JSON:
  `@grafana get dashboard <dashboard-uid> and save it to dashboards/<name>.json`
- To update a dashboard from JSON:
  `@grafana update dashboard from dashboards/<name>.json`
- To provision a dashboard:
  `cp dashboards/<name>.json provisioning/dashboards/ && docker-compose restart grafana`

## References
- See `README.md` for full workflow, setup, and troubleshooting
- Key files: `docker-compose.yml`, `provisioning/`, `dashboards/`, `.env.example`, `README.md`

---
For any unclear or missing conventions, review the README or ask for clarification.