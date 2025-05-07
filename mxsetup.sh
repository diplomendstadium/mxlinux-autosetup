#!/bin/bash


echo " "
echo "----------------------------------------"
echo "Welcome to the MX Linux Auto-Setup!"
echo "https://github.com/diplomendstadium/mxlinux-autosetup/"
echo "----------------------------------------"
echo " "

# change to users home directory
cd ~

# Update the System
echo "[Info] Updating the system..."
sudo apt update
sudo apt full-upgrade -y
echo "[Info] Relax, flatpak updates can take some time if there is nothing to do..."
flatpak update -y

# Installing Packages
echo "[Info] Installing Software via apt..."
sudo apt update
sudo apt install -y \
    borgbackup \
    cockpit \
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
    syncthing \
    thunderbird-l10n-de \
    tldr \
    tor torsocks \
    veracrypt \
    vim \
    virt-manager \
    virtualbox virtualbox-ext-pack virtualbox-guest-additions-iso \
    xwallpaper

# Install flatpaks
echo "[Info] Setting up Flathub..."
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
echo "[Info] Installing Flatpaks..."
flatpak install -y \
    org.torproject.torbrowser-launcher \
    org.onlyoffice.desktopeditors

# AppImages
echo "[Info] Downloading AppImages..."
curl -OL https://github.com/cryptomator/cryptomator/releases/download/1.16.0/cryptomator-1.16.0-x86_64.AppImage
sudo chmod u+x cryptomator-1.16.0-x86_64.AppImage

# Signal
echo "[Info] Adding Signal Messenger..."
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' | sudo tee /etc/apt/sources.list.d/signal-xenial.list
sudo apt update && sudo apt install signal-desktop

# Activate and enable UFW firewall
echo "[INFO] Setting up SSH..."
sudo apt install openssh-server
sudo service ssh start

# Activate and enable UFW firewall
echo "[INFO] Activate the firewall..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 9090 # For Cockpit
sudo ufw allow syncthing
sudo ufw enable

# Cleanup
sudo apt autoremove -y --purge
sudo apt autoclean -y


echo " "
echo "----------------------------------------"
echo "Done. System will restart in 30seconds."
echo "To abort please stop this script with Strg+C"
echo "----------------------------------------"
echo " "

# reboot
sleep 30
sudo reboot
