#!/bin/bash
# Script modificato per uBlue-os (Global System-wide install)

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Target per i file di configurazione (verranno copiati ai nuovi utenti)
readonly SKEL_CONFIG="/etc/skel/.config"
readonly SKEL_LOCAL="/etc/skel/.local/share"

# Prepariamo le directory
mkdir -p /usr/share/themes /usr/share/icons /usr/share/fonts /usr/share/wallpapers
mkdir -p "$SKEL_CONFIG" "$SKEL_LOCAL/plasma"

# Forza la distro a fedora (standard per uBlue)
DISTRO="fedora"
PLASMA_CONFIG_ZIP="assets/plasma6macos-kde-config.zip"

echo "🚀 Avvio installazione globale macOS Theme..."

# 1. Temi e Icone (Sistema)
unzip -o "${SCRIPT_DIR}/assets/plasma6macos-plasma-theme.zip" "aurorae/*" "color-schemes/*" "plasma/*" -d /usr/share/
unzip -o "${SCRIPT_DIR}/assets/plasma6macos-gtk-theme.zip" "MacTahoe-*" -d /usr/share/themes/
unzip -o "${SCRIPT_DIR}/assets/plasma6macos-icons.zip" "MacTahoe*" -d /usr/share/icons/
unzip -o "${SCRIPT_DIR}/assets/plasma6macos-cursors.zip" "WhiteSur-cursors/*" -d /usr/share/icons/
unzip -o "${SCRIPT_DIR}/assets/plasma6macos-fonts.zip" -d /usr/share/fonts/
unzip -o "${SCRIPT_DIR}/assets/plasma6macos-wallpapers.zip" -d /

# 2. Plasmoidi e KWin Effects (Globali)
unzip -o "${SCRIPT_DIR}/assets/plasma6macos-plasmoids.zip" "plasmoids/*" -d /usr/share/plasma/
unzip -o "${SCRIPT_DIR}/assets/plasma6macos-kwin-effect.zip" "kwin/*" -d /usr/share/

# 3. Configurazioni Default (Skeleton)
# Copiamo i file che definiscono il layout del desktop in /etc/skel
unzip -o "${SCRIPT_DIR}/${PLASMA_CONFIG_ZIP}" ".face" ".face.icon" -d /etc/skel/
unzip -o "${SCRIPT_DIR}/${PLASMA_CONFIG_ZIP}" \
    "gtk-3.0/*" "gtk-4.0/*" "xsettingsd/*" "Trolltech.conf" "darklyrc" "dolphinrc" \
    "kdeglobals" "kwinrc" "plasmarc" "plasmashellrc" \
    "plasma-org.kde.plasma.desktop-appletsrc" -d "$SKEL_CONFIG/"

# Nota: Su uBlue, usa i file specifici per Fedora/RedHat
unzip -oj "${SCRIPT_DIR}/${PLASMA_CONFIG_ZIP}" "fedora/plasma-org.kde.plasma.desktop-appletsrc" -d "$SKEL_CONFIG/"

# 4. SDDM (Login Screen)
# In un container uBlue, questi file vanno direttamente in /usr/share/sddm
unzip -o "${SCRIPT_DIR}/assets/plasma6macos-sddm.zip" "tahoe-sddm/*" "tahoe-sddm-dark/*" -d /usr/share/sddm/themes/