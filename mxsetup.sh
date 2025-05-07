#!/bin/bash


echo " "
echo "----------------------------------------"
echo "Welcome to the MX Linux Auto-Setup!"
echo "https://github.com/diplomendstadium/mxlinux-autosetup/"
echo "----------------------------------------"
echo " "

# Update the System
echo "[Info] Updating the system..."
sudo apt update
sudo apt full-upgrade -y
flatpak update -y

# Installing Packages
echo "[Info] Installing Software..."
sudo apt update
sudo apt install -y \
    borgbackup \
    ffmpeg \
    firefox-l10n-xpi-de \
    gimp \
    gnome-disk-utility \
    hunspell-de-de \
    idle \
    keepassxc \
    kleopatra \
    magic-wormhole \
    onionshare onionshare-cli \
    thunderbird-l10n-de \
    tldr \
    tor torsocks \
    vim

# Install further software via flatpak
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install -y \
    org.torproject.torbrowser-launcher \
    org.onlyoffice.desktopeditors
    
# Activate and enable UFW firewall
echo "[INFO] Setting up SSH..."
sudo apt install openssh-server
sudo service ssh start

# Activate and enable UFW firewall
echo "[INFO] Activate the firewall..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw enable

# Cleanup
sudo apt autoremove -y --purge
sudo apt autoclean -y

echo " "
echo "----------------------------------------"
echo "Done. System will restart in 30seconds."
echo "To abort please stop this script with Strg+X"
echo "----------------------------------------"
echo " "

# reboot
sleep 30
sudo reboot
