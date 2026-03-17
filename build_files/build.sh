#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux 

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
echo "--- Inizio configurazione ambiente Pantheon ---"

# 1. Pulizia dei pacchetti GNOME esistenti
# In un container, dnf remove è più rapido di rpm-ostree
echo "Rimozione dei componenti GNOME..."
dnf remove -y \
    gnome-shell \
    gnome-session \
    nautilus \
    mutter \

# 2. Installazione del Desktop Environment Pantheon
# Il gruppo 'pantheon-desktop' contiene tutto il necessario per elementary OS
echo "Installazione di Pantheon..."
dnf install -y \
    @pantheon-desktop \
    pantheon-session-settings \
    lightdm-pantheon-greeter \
    wingpanel \
    plank

# 3. Pulizia della cache per ridurre la dimensione dell'immagine
echo "Pulizia post-installazione..."
dnf clean all
rm -rf /var/cache/dnf

echo "--- Installazione completata ---"
