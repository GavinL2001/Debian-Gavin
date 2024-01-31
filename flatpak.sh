#!/bin/bash

if [[ $EUID = 0 ]]; then
  echo "Don't run this script as root." 2>&1
  exit 1
fi

# Install Flatpak
sudo nala update
sudo nala install -y flatpak

# Flatpak Packages
flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install --user -y \
    com.bitwarden.desktop \
    com.chatterino.chatterino//stable \
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
    net.davidotek.pupgui2 \
    org.kde.kcalc

printf "Flatpak installation complete!"