#!/bin/bash

# Change from bookworm to sid
# sudo sed -i 's+bookworm +unstable +g' /etc/apt/sources.list

# Updating Existing Packages
# sudo apt update && apt full-upgrade -y &&

# Add xanmod repository
sudo apt install -y gpg wget &&
wget -qO - https://dl.xanmod.org/archive.key | sudo gpg --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg &&
echo 'deb [signed-by=/usr/share/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main' | sudo tee /etc/apt/sources.list.d/xanmod-release.list &&
sudo apt update &&

# Add Lutris repository
echo "deb [signed-by=/etc/apt/keyrings/lutris.gpg] https://download.opensuse.org/repositories/home:/strycore/Debian_12/ ./" | sudo tee /etc/apt/sources.list.d/lutris.list > /dev/null
wget -q -O- https://download.opensuse.org/repositories/home:/strycore/Debian_12/Release.key | gpg --dearmor | sudo tee /etc/apt/keyrings/lutris.gpg > /dev/null

# Installing New Packages
sudo apt install -y \
    autojump \
    btop \
    cron \
    flatpak \
    gamemode \
    gamescope \
    git \
    grep \
    imagemagick \
    kcalc \
    kde-spectacle \
    kitty \
    libglx-mesa0:i386 \
    libgl1-mesa-dri:i386 \
    libheif1 \
    linux-xanmod-edge-x64v3 \
    locate \
    lutris \
    lxpolkit \
    mesa-drm-shim \
    mesa-va-drivers \
    mesa-vulkan-drivers \
    mesa-vulkan-drivers:i386 \
    nala \
    nano \
    neofetch \
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
    rsync \
    sddm \
    steam-installer \
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
# get_latest () { 
#     curl --silent "https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest" |
#     grep '"tag_name":' |
#     sed -E 's/.*"([^"]+)".*/\1/'
# }
# latest=$(get_latest)
# apt install https://github.com/fastfetch-cli/fastfetch/releases/download/$latest/fastfetch-$latest-Linux.deb &&


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