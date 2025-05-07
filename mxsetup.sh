#!/bin/bash

# Ensure script is run with sudo/root privileges
if [[ $EUID -ne 0 ]]; then
    echo "[INFO] This script requires root rights. Start it again with sudo..."
    exec sudo bash "$0" "$@"
fi

echo " "
echo "----------------------------------------"
echo "Welcome to the MX Linux Auto-Setup!"
echo "https://github.com/diplomendstadium/mxlinux-autosetup/"
echo "----------------------------------------"
echo " "

# Update the System
echo "[Info] Updating the system..."
sudo apt update
sudo apt full-upgade -y

# Installing Packages
echo "[Info] Installing Software..."
sudo apt update
sudo apt install -y /
    

# Activate and enable UFW firewall
#echo "[INFO] Activate the firewall..."
#sudo ufw enable
#sudo systemctl enable ufw

# Cleanup
sudo apt autoremove -y --purge
sudo apt autoclean -y

echo " "
echo "----------------------------------------"
echo "Done. System will restart in 30seconds. To abort please stop this script with Strg+X"
echo "----------------------------------------"
echo " "

# reboot
sleep 30
sudo reboot
