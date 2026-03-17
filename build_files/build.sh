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

# Create autostart script for first login
cat << 'AUTOSTART' > /usr/bin/install-mac-theme-first-login.sh
#!/bin/bash
if [ ! -f "$HOME/.config/mac-theme-installed" ]; then
    if [ -x "/osx/plasma6-macos/install.sh" ]; then
        cp -Rp /osx/plasma6-macos $HOME
        $HOME/plasma6-macos/install.sh
    else
        bash $HOME/plasma6-macos/install.sh
    fi
    mkdir -p "$HOME/.config"
    touch "$HOME/.config/mac-theme-installed"
fi
AUTOSTART
chmod +x /usr/bin/install-mac-theme-first-login.sh

# Create XDG autostart entry
mkdir -p /etc/xdg/autostart
cat << 'DESKTOP' > /etc/xdg/autostart/install-mac-theme.desktop
[Desktop Entry]
Type=Application
Exec=konsole -e /usr/bin/install-mac-theme-first-login.sh
Terminal=true
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Install Mac Theme
Comment=Installs Mac Theme on first login
DESKTOP
