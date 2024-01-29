#!/bin/bash
set -e

((
# Set username
user=gavin

run_as_user () {
    sudo -H -u $user bash -c
}

# Initial user setup
if [[ $EUID -ne 0 ]]; then
  echo "You must be the root user to run this script, please login as root" 2>&1
  exit 1
fi

# Install basic packages
apt update
apt install -y sudo nala timeshift

#Add user to sudo group
usermod -aG sudo gavin

# Create initial back-up
run_as_user timeshift --btrfs --create --comments "after initial install"

# Get faster mirrors
nala fetch --auto --non-free --https-only -y
nala update

# Add initial packages
nala install -y gpg wget curl

# Add Xanmod repository
wget -qO - https://dl.xanmod.org/archive.key | gpg --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg
echo 'deb [signed-by=/usr/share/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main' | tee /etc/apt/sources.list.d/xanmod-release.list

# Installing New Packages
nala install -y \
    autojump \
    btop \
    flatpak \
    gamemode \
    gamescope \
    git \
    imagemagick \
    kcalc \
    kde-spectacle \
    kitty \
    libglx-mesa0 \
    libgl1-mesa-dri \
    libheif1 \
    linux-xanmod-edge-x64v3 \
    locate \
    lutris \
    lxpolkit \
    mesa-drm-shim \
    mesa-va-drivers \
    mesa-vulkan-drivers \
    network-manager \
    openssh-client \
    pavucontrol-qt \
    pcmanfm \
    pipewire \
    pipx \
    protontricks \
    puddletag \
    qemu-utils \
    qimgv \
    radeontop \
    sddm \
    steam-installer \
    tldr \
    trash-cli \
    ufw \
    winetricks \
    wireguard \
    wireguard-tools \
    zsh \
    zsh-autosuggestions

# Clean up leftover cache
nala clean

# Fastfetch Install
get_latest () { 
    curl --silent "https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest" |
    grep '"tag_name":' |
    sed -E 's/.*"([^"]+)".*/\1/'
}
latest=$(get_latest)
nala install https://github.com/fastfetch-cli/fastfetch/releases/download/$latest/fastfetch-$latest-Linux.deb

# Flatpak Install
run_as_user 'flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo'
run_as_user 'flatpak install --user -y flathub \
    com.bitwarden.desktop \
    com.chatterino.chatterino \
    com.discordapp.Discord \
    com.github.tchx84.Flatseal \
    com.spotify.Client \
    com.usebottles.bottles \
    com.vscodium.codium \
    io.github.dweymouth.supersonic \
    org.audacityteam.Audacity \
    org.avidemux.Avidemux \
    org.bleachbit.BleachBit \
    org.gimp.GIMP \
    org.telegram.desktop \
    us.zoom.Zoom \
    org.libreoffice.LibreOffice \
    one.ablaze.floorp \
    net.davidotek.pupgui2'

# Create second back-up
timeshift --btrfs --create --comments "pre-sid upgrade"

# Get sid mirrors
nala fetch --auto --non-free --https-only --debian sid -y

# Updating Existing Packages
nala update
nala upgrade -y

# Post-install Things
ufw enable
run_as_user 'chsh -s $(which zsh)'

# Create post-install back-up
timeshift --btrfs --create --comments "after installation"

printf "Initial setup completed!\nPlease install Hyprland using this script here:\nhttps://github.com/JaKooLit/Debian-Hyprland\n"
printf "Log file saved at /home/$user/debian-installer.log\n"

) 2>&1) | tee -a /home/$user/debian-installer.log