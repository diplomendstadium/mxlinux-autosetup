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
echo "[Info] Relax, flatpak updates can take some time if there is nothing to do..."
flatpak update -y

# Set wallpaper
echo "[INFO] Working on a new Wallpaper..."
WALLPAPER_URL="https://www.schloss-lichtenstein.de/images/os_imagegallery_109/original/1.jpg"
WALLPAPER_NAME="lichtenstein.jpg"
#WALLPAPER_URL="https://wallpapers.com/images/hd/linux-penguin-and-rainbow-background-imsv6hxt0e8zcl7m.jpg"
#WALLPAPER_NAME="linux.jpg"
WALLPAPER_PATH="/home/$USER/$WALLPAPER_NAME"
curl -L "$WALLPAPER_URL" -o "$WALLPAPER_PATH"
sudo -u "$SUDO_USER" xfconf-query \
    --channel xfce4-desktop \
    --property /backdrop/screen0/monitor0/image-path \
    --set "$WALLPAPER_PATH"

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
    thunderbird-l10n-de \
    tldr \
    tor torsocks \
    vim

# Install flatpaks
echo "[Info] Setting up Flathub..."
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
echo "[Info] Installing Flatpaks..."
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
sudo ufw allow 9090 # For Cockpit
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
