# THIS FILE IS A BASH SCERIPT CREATED FOR THE COMPLETE INSTALLATION OF WAZUH MCP SERVER & CLAUDE DESKTOP
############

#!/bin/bash

echo "===Installing curl==="
sudo apt install curl

echo "===Installing Wazuh==="
curl -sO https://packages.wazuh.com/4.12/wazuh-install.sh && sudo bash ./wazuh-install.sh -a

echo "===Creating Password File==="
sudo tar -O -xvf wazuh-install-files.tar wazuh-install-files/wazuh-passwords.txt > wazuh-password.txt

sudo sed -i "s/^deb /#deb /" /etc/apt/sources.list.d/wazuh.list

sudo apt update

echo "===Installing net-tools==="
sudo apt install net-tools

ifconfig
echo "!!!Please take a note of your ip address we will use it later!!!"


