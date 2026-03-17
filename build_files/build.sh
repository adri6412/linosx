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
# 2. Rimozione Desktop Environment esistente (GNOME)
echo "Rimozione GNOME in corso..."
dnf remove -y gnome-shell nautilus mutter --setopt=protected_packages=
dnf groupinstall -y "Budgie Desktop"

# 5. Pulizia per ridurre il peso del layer
dnf clean all
rm -rf /var/cache/dnf

echo "--- Installazione completata con successo ---"
