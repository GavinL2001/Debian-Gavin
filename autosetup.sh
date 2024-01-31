#!/bin/bash
set -e

# Set username
user=gavin

# Initial user setup
if [[ $EUID -ne 0 ]]; then
  echo "You must login as root to run this script." 2>&1
  exit 1
fi

# Install basic packages
apt update
apt install -y sudo nala timeshift gpg ufw

# Activate dbus service
systemctl start dbus

#Add user to sudo group
usermod -aG sudo $user

# Enable firewall
ufw enable

# Fix debian root directory subvolume name for timeshift backups
sed -i 's+@rootfs+@+g' /etc/fstab

# Create second back-up
timeshift --btrfs --create --comments "pre-sid upgrade"

# Get sid mirrors
sed -i 's+@bookworm +sid contrib+g' /etc/apt/sources.list
nala fetch --auto --non-free --https-only --debian sid -y

# Add Xanmod repository
curl -s https://dl.xanmod.org/archive.key | gpg --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg
echo 'deb [signed-by=/usr/share/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main' | tee /etc/apt/sources.list.d/xanmod-release.list

# Add Prism Launcher repository
curl -q 'https://proget.makedeb.org/debian-feeds/prebuilt-mpr.pub' | gpg --dearmor | tee /usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg 1> /dev/null
echo "deb [signed-by=/usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg] https://proget.makedeb.org prebuilt-mpr $(lsb_release -cs)" | tee /etc/apt/sources.list.d/prebuilt-mpr.list
sed -i 's+trixie+bookworm+g' /etc/apt/sources.list.d/prebuilt-mpr.list

# Install Packages
nala update
sleep 3
nala install -y \
    autojump \
    btop \
    flameshot \
    flatpak \
    gamemode \
    gamescope \
    gh \
    git \
    imagemagick \
    kitty \
    libglx-mesa0 \
    libgl1-mesa-dri \
    libheif1 \
    linux-xanmod-edge-x64v3 \
    locate \
    lutris \
    network-manager \
    neofetch \
    openjdk-8-jre-headless \
    openjdk-17-jre-headless \
    openssh-client \
    pavucontrol-qt \
    pcmanfm \
    pipewire \
    pipx \
    prismlauncher \
    protontricks \
    puddletag \
    qemu-utils \
    qimgv \
    radeontop \
    steam-installer \
    tldr \
    trash-cli \
    wget \
    winetricks \
    wireguard \
    wireguard-tools \
    zsh \
    zsh-autosuggestions

nala install -t bookworm -y \
  vulkan-validationlayers-dev \
  vulkan-validationlayers

# Clean up leftover cache
nala clean
nala autoremove -y

# Updating Remaining Packages
sleep 3
nala update
nala upgrade --no-autoremove -y
nala clean

# Create post-install back-up
timeshift --btrfs --create --comments "after installation"

printf "Initial setup completed!\nPlease install Hyprland using this script here:\nhttps://github.com/JaKooLit/Debian-Hyprland\n"
printf "Run 'curl -sL https://www.gavinliddell.us/flatpak | bash' to install flatpak packages.\n"
printf "Run 'chsh -s $(which zsh)' to switch to zsh\n"
