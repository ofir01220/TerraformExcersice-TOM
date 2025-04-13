#!/bin/bash
# Enable rigorous error checking and command logging
set -e # Exit immediately if a command exits with a non-zero status.
set -x # Print commands and their arguments as they are executed.

# Define log file
LOG_FILE="/var/log/openvpn-as-install.log"

# Redirect all output (stdout and stderr) to the log file and also to the console (if viewing live)
exec > >(tee -a $${LOG_FILE}) 2>&1

echo ">>> Starting OpenVPN Access Server Installation Script at $(date) <<<"

# --- Update packages and install wget (just in case) ---

#Tom in our case we are usually using debian ubuntu but I provided a wider option in case using yum package manager
echo ">>> Updating packages and ensuring wget is installed... <<<"
if command -v apt-get &> /dev/null; then
    export DEBIAN_FRONTEND=noninteractive # Avoid prompts
    apt-get update -y
    apt-get install -y wget
    PKG_MGR="apt"
elif command -v yum &> /dev/null; then
    yum update -y
    yum install -y wget
    PKG_MGR="yum"
else
    echo "ERROR: Unsupported package manager (neither apt nor yum found). Exiting."
    exit 1
fi
echo ">>> Package update/wget check complete using $${PKG_MGR}. <<<"

# --- Download and Run OpenVPN AS Installer ---
echo ">>> Downloading OpenVPN AS installer... <<<"
INSTALL_SCRIPT_URL="https://packages.openvpn.net/as/install.sh"
INSTALL_SCRIPT_PATH="/tmp/install-openvpn-as.sh" # Download to /tmp

wget -O $${INSTALL_SCRIPT_PATH} $${INSTALL_SCRIPT_URL}
chmod +x $${INSTALL_SCRIPT_PATH}

echo ">>> Running OpenVPN AS installer with --yes flag... <<<"
# Run with bash, not sudo bash, as user_data usually runs as root already.
# The --yes flag accepts the EULA and uses defaults non-interactively.
bash $${INSTALL_SCRIPT_PATH} --yes

echo ">>> OpenVPN Access Server Installation Script Finished at $(date) <<<"
echo ">>> Check $${LOG_FILE} for details. <<<"
echo ">>> IMPORTANT: Check system logs (/var/log/messages, /var/log/syslog, or journalctl)"
echo ">>> or AS logs (/usr/local/openvpn_as/init.log) for the initial 'openvpn' admin password! <<<"

exit 0
