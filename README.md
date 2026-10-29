# Wazuh MCP Server + Claude Desktop Setup Guide

This guide walks through setting up a **Wazuh server**, a separate **Wazuh agent**, **Atomic Red Team**, **Claude Desktop**, and a **Wazuh MCP server** so that Wazuh SIEM data can be queried using natural language.

## Requirements

You will need two Ubuntu 24.04 endpoints:

1. **Wazuh Server Endpoint**  
   This endpoint hosts the Wazuh central components:
   - Wazuh server
   - Wazuh indexer
   - Wazuh dashboard
   - Claude Desktop
   - Wazuh MCP server

2. **Wazuh Agent Endpoint**  
   This endpoint runs:
   - Wazuh agent
   - Atomic Red Team, used to simulate MITRE ATT&CK activity

---

## Setup Steps

### Step 1 — Clone the Repository

Clone the repository that contains the installation scripts and MCP configuration file.

```bash
git clone <repository-url>
```

Replace `<repository-url>` with the repository URL you are using.

### Step 2 — Enter the Repository Directory

```bash
cd <repo_name>
```

Replace `<repo_name>` with the cloned repository directory name.

### Step 3 — Prepare the Wazuh Server Endpoint

From the repository, keep the following files on the Ubuntu endpoint that will act as the **Wazuh Server**:

- `server_installation1.sh`
- `server_installation2.sh`
- `mcpServers wazuh config.txt`

### Step 4 — Prepare the Wazuh Agent Endpoint

Copy the following file to the Ubuntu endpoint that will act as the **Wazuh Agent**:

- `Agent_installation1.sh`

### Step 5 — Run the First Wazuh Server Installation Script

On the **Wazuh Server** endpoint, run:

```bash
chmod +x server_installation1.sh
./server_installation1.sh
```

### Step 6 — Record the Server IP and Wazuh Credentials

The first installation script performs the initial part of the Wazuh setup.

At the end of the script execution:

- Note the **IP address** displayed by the script. You will need it while configuring the Wazuh Agent.
- A file named `wazuh-password.txt` will be created in the current terminal directory.
- This file contains the Wazuh usernames and passwords needed later in the setup.

You can access the Wazuh Dashboard at:

```text
https://localhost:443
```

Use the appropriate Wazuh/indexer credentials stored in `wazuh-password.txt` to sign in.

> Keep `wazuh-password.txt` secure because it contains sensitive credentials.

### Step 7 — Install and Connect the Wazuh Agent

Go to the **Wazuh Agent** endpoint where `Agent_installation1.sh` is stored and run:

```bash
chmod +x Agent_installation1.sh
./Agent_installation1.sh
```

When prompted, enter the **Wazuh Server IP address** recorded in Step 6.

### Step 8 — Generate Security Events with Atomic Red Team

The agent installation script sets up the required environment and uses **Atomic Red Team** on the Wazuh Agent endpoint to simulate MITRE ATT&CK activity.

The simulated activity is detected by the Wazuh server and produces security logs and alerts that can later be queried through Claude using the MCP integration.

### Step 9 — Install Claude Desktop and the Wazuh MCP Server

Return to the **Wazuh Server** endpoint and run:

```bash
chmod +x server_installation2.sh
./server_installation2.sh
```

This script installs:

- Claude Desktop
- Wazuh MCP Server

---

## Configure Claude Desktop

### Step 10 — Start Claude Desktop and Sign In

Open Claude Desktop. On first launch, you may see the initial setup screen.

![Claude Desktop initial Get Started screen](assets/02-claude-get-started.jpeg)

**Figure 1 — Claude Desktop initial setup screen.**

Complete the sign-in process using your Claude account. A free account can be used for this setup.

After signing in, the Claude Desktop home screen should appear.

![Claude Desktop home screen](assets/03-claude-home-screen.jpeg)

**Figure 2 — Claude Desktop after sign-in.**

### Step 11 — Open Claude Developer Settings

From the Claude Desktop menu, navigate to:

```text
File > Settings
```

![Claude File menu showing Settings](assets/04-claude-file-settings.jpeg)

**Figure 3 — Opening Claude Desktop Settings from the File menu.**

In **Settings**, select **Developer** and click **Edit Config**.

![Claude Developer settings with Edit Config](assets/05-claude-developer-edit-config.jpeg)

**Figure 4 — Developer settings and the Edit Config option.**

### Step 12 — Open `claude_desktop_config.json`

After clicking **Edit Config**, locate and open:

```text
claude_desktop_config.json
```

On Linux, the file is typically visible inside Claude's configuration directory, as shown below.

![Claude configuration directory containing claude_desktop_config.json](assets/06-claude-config-file.jpeg)

**Figure 5 — Claude configuration directory and `claude_desktop_config.json`.**

### Step 13 — Add the Wazuh MCP Configuration

Open the previously saved file:

```text
mcpServers wazuh config.txt
```

Copy its entire contents into `claude_desktop_config.json`.

Make sure the JSON file contains the required MCP configuration and update the relevant fields using the credentials stored in:

```text
wazuh-password.txt
```

For the host value, use:

```text
localhost
```

Save the JSON file after making the required changes.

> Do not publish screenshots or configuration files containing real usernames, passwords, API keys, or other secrets.

### Step 14 — Restart Claude Desktop and Verify the MCP Server

Restart Claude Desktop after saving the configuration.

Return to:

```text
File > Settings > Developer
```

The **Wazuh MCP server** should now appear with a **running** status.

![Wazuh MCP server running in Claude Developer settings](assets/07-wazuh-mcp-running.jpeg)

**Figure 6 — Wazuh MCP server successfully running in Claude Desktop.**

---

## Test the Wazuh MCP Integration

Once the MCP server is running, you can ask Claude questions about the Wazuh SIEM using natural language.

For example:

```text
What are the latest SIEM alerts?
```

The first time Claude invokes a Wazuh MCP tool, it may ask for permission to use the external integration.

![Claude requesting permission to use the Wazuh MCP integration](assets/09-claude-external-integration-permission.jpeg)

**Figure 7 — Claude requesting permission before invoking the Wazuh MCP tool.**

Review the requested action and allow it if it matches what you expect.

After the request is approved, Claude can retrieve Wazuh information and present the SIEM alerts in natural language.

![Claude showing latest Wazuh SIEM alerts](assets/10-latest-siem-alerts.jpeg)

**Figure 8 — Example response showing recent Wazuh SIEM alerts.**

You can also verify that the Wazuh connector/tool is enabled from the Claude conversation interface.

![Wazuh connector enabled in Claude](assets/11-wazuh-connector-enabled.jpeg)

**Figure 9 — Wazuh connector enabled and available to Claude.**

---

## Verification Checklist

At the end of the setup, verify that:

- The Wazuh server, indexer, and dashboard are running.
- The Wazuh Agent is registered with the Wazuh Server.
- Atomic Red Team activity generates detectable Wazuh events.
- Claude Desktop is installed and signed in.
- `claude_desktop_config.json` contains the Wazuh MCP configuration.
- The Wazuh MCP server shows **running** in Claude Developer settings.
- Claude requests permission when invoking the MCP integration.
- Claude can retrieve and summarize Wazuh SIEM alerts.
curl -fsSL https://packages.wazuh.com/key/GPG-KEY-WAZUH | sudo gpg --dearmor --yes -o /usr/share/keyrings/wazuh.gpg
sudo chmod 644 /usr/share/keyrings/wazuh.gpg
## Result
https://medium.com/@iamblacklight/bringing-ai-to-siem-my-experiment-with-wazuh-mcp-server-and-claude-desktop-09f2aa15165d
The environment is now configured so that the Wazuh SIEM can be queried through Claude Desktop using natural-language prompts via the Wazuh MCP server.
