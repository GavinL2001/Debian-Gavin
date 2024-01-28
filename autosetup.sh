#!/bin/bash

# Updating Existing Packages
sudo apt update && apt upgrade -y &&

# Add xanmod repository
sudo apt install -y wget &&
wget -qO - https://dl.xanmod.org/archive.key | sudo gpg --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg &&
echo 'deb [signed-by=/usr/share/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main' | sudo tee /etc/apt/sources.list.d/xanmod-release.list &&
sudo apt update &&

# Installing New Packages
sudo apt install -y \
    autojump \
    btop \
    cat \
    cron \
    curl \
    flatpak \
    gamemode \
    gamescope \
    git \
    grep \
    imagemagick \
    jackd \
    kcalc \
    kde-spectacle \
    kitty \
    libheif1 \
    linux-xanmod-edge-x64v3 \
    locate \
    lutris \
    lxpolkit \
    mesa \
    mesa-drm-shim \
    mesa-va-drivers \
    mesa-vulkan-drivers \
    nala \
    nano \
    network-manager \
    nmtui \
    openssh-client \
    pavucontrol-qt \
    pcmanfm \
    pipewire \
    pipewire-audio \
    pipewire-jack \
    pipewire-pulse \
    pipx \
    protontricks \
    puddletag \
    pulseaudio \
    qemu-utils \
    qimgv \
    radeontop \
    rsync \
    sddm \
    steam \
    timeshift \
    tldr \
    trash-cli \
    ufw \
    wayland-protocols \
    wayland-utils \
    winetricks \
    wireguard \
    wireguard-tools \
    xwayland \
    zsh \
    zsh-autosuggestions &&

# Fastfetch Install
get_latest_version() { 
    curl --silent "https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest" |
    grep '"tag_name":' |
    sed -E 's/.*"([^"]+)".*/\1/'
}
latest=$(get_latest_version)
apt install https://github.com/fastfetch-cli/fastfetch/releases/download/$latest/fastfetch-$latest-Linux.deb &&


# Flatpak Install
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo &&
flatpak install --user -y flathub \
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
    net.davidotek.pupgui2 &&

# Post-install Things
timeshift --btrfs --create --comments "after initial install" &&
sudo ufw enable &&
# ln -s $HOME/floorp/floorp-bin /usr/bin &&
chsh -s $(which zsh) &&

printf "Initial setup completed!\nInstall Hyprland using this script here:\nhttps://github.com/JaKooLit/Debian-Hyprland\n"