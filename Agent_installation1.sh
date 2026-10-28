#THIS SCRIPT SETS UP THE WAZUH AGENT & ATOMIC RED TEAM & SIMULATES MITRE ATT&CK ON WAZUH SERVER 

#!/bin/bash

sudo apt install curl

sudo apt install net-tools

apt-get install gnupg apt-transport-https

curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import && chmod 644 /usr/share/keyrings/wazuh.gpg

echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list

apt-get update

read -p "Enter Wazuh Server IP address: " WAZUH_SERVER

if [ -z "$WAZUH_SERVER" ]; then
    echo "Error: No IP address entered."
    exit 1
fi

sudo env WAZUH_MANAGER="$WAZUH_SERVER" apt-get install wazuh-agent

systemctl daemon-reload

systemctl enable wazuh-agent

systemctl start wazuh-agent

sed -i "s/^deb /#deb /" /etc/apt/sources.list.d/wazuh.list

sudo apt-get update

# Install pre-requisite packages.
sudo apt-get install -y wget apt-transport-https software-properties-common

# Get the version of Ubuntu
source /etc/os-release

# Download the Microsoft repository keys
wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb

# Register the Microsoft repository keys
sudo dpkg -i packages-microsoft-prod.deb

# Delete the Microsoft repository keys file
rm packages-microsoft-prod.deb

# Update the list of packages after we added packages.microsoft.com
sudo apt-get update

###################################
# Install PowerShell
sudo apt-get install -y powershell

# Start PowerShell
pwsh

IEX (IWR 'https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicredteam.ps1' -UseBasicParsing);

Install-AtomicRedTeam -getAtomics

Invoke-AtomicTest T1110.001 -CheckPrereqs

Invoke-AtomicTest T1110.001

