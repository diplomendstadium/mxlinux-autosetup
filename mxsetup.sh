#!/bin/bash


echo " "
echo " "
cat << "EOF"
       .---.
      /     \
      \.@-@./  Welcome to the MX Linux Auto-Setup!
      /`\_/`\  https://github.com/diplomendstadium/mxlinux-autosetup/
     //  _  \\
    | \     )|_
   /`\_`>  <_/ \
   \__/'---'\__/
EOF
echo " "

sleep 1
echo ""
echo "If you have not looked at the contents of this script thoroughly or have already executed it, you should cancel as fast as possible with Ctrl + C!"
echo ""
sleep 10

# change to users home directory
cd ~

# Update the System
echo "[Info] Updating the system..."
sudo apt update
sudo apt full-upgrade -y
echo "[Info] Relax, flatpak updates can take some time if there is nothing to do..."
flatpak update -y
echo "" && sleep 3

# Modify BashRC
echo "[Info] Changing BashRC..."
echo 'echo "With power comes responsibility."' >> .bashrc
echo 'echo""' >> .bashrc
echo 'date' >> .bashrc
echo 'ncal -Mbw' >> .bashrc
echo "" && sleep 3

# Installing Packages
echo "[Info] Installing Software via apt..."
sudo apt update
sudo apt install -y \
    borgbackup \
    cockpit \
    ffmpeg \
    firefox-l10n-xpi-de \
    fish \
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
    tmux \
    tor torsocks \
    veracrypt \
    vim \
    virt-manager \
    virtualbox virtualbox-ext-pack virtualbox-guest-additions-iso \
    w3m
echo "" && sleep 3

# Install flatpaks
echo "[Info] Setting up Flathub..."
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
echo "[Info] Installing Flatpaks..."
flatpak install -y \
    org.torproject.torbrowser-launcher \
    org.onlyoffice.desktopeditors
echo "" && sleep 3

# AppImages
echo "[Info] Downloading AppImages..."
curl -OL https://github.com/cryptomator/cryptomator/releases/download/1.16.0/cryptomator-1.16.0-x86_64.AppImage
sudo chmod u+x cryptomator-1.16.0-x86_64.AppImage
echo "" && sleep 3

# Signal
echo "[Info] Adding Signal Messenger..."
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' | sudo tee /etc/apt/sources.list.d/signal-xenial.list
sudo apt update && sudo apt install signal-desktop
echo "" && sleep 3

# Activate and enable UFW firewall
echo "[INFO] Setting up SSH..."
sudo apt install openssh-server
sudo service ssh start
echo "" && sleep 3

# Activate and enable UFW firewall
echo "[INFO] Activate the firewall..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 9090 # For Cockpit
sudo ufw allow syncthing
sudo ufw enable
echo "" && sleep 3

# Firefox
# https://mozilla.github.io/policy-templates/ and https://linuxconfig.org/how-to-customize-firefox-using-the-policies-json-file for more info
echo "[INFO] Creating Policies for Firefox..."
sudo mkdir -p /etc/firefox/policies
sudo tee /etc/firefox/policies/policies.json > /dev/null <<EOF
{
  "policies": {
    "DisableTelemetry": true,
    "Extensions": {
      "Install": [
        "https://addons.mozilla.org/firefox/downloads/file/4458450/ublock_origin-1.63.2.xpi"
      ]
    },
    "SanitizeOnShutdown": {
      "Cache": true,
      "Cookies": true,
      "FormData": true,
      "History": true,
      "Sessions": true,
      "SiteSettings": true,
      "Locked": true
    }
  }
}
EOF
echo "" && sleep 3

# Cleanup
echo "[INFO] Cleaning the system..."
sudo apt autoremove -y --purge
sudo apt autoclean -y
echo "" && sleep 3

echo " "
echo "Done. System will restart in 60 seconds."
echo "To abort please stop this script with Strg+C"
echo " "

# reboot
sleep 60
sudo reboot
