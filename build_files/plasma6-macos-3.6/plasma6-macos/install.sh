#!/bin/bash
# install.sh - Configurazione globale macOS per uBlue-os
set -uo pipefail

# Percorsi di sistema
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SKEL_CONFIG="/etc/skel/.config"
readonly SKEL_LOCAL="/etc/skel/.local/share"
readonly ASSETS_DIR="${SCRIPT_DIR}/assets"

echo "🚀 Avvio installazione globale macOS Theme..."

# Creazione directory necessarie
mkdir -p /usr/share/themes /usr/share/icons /usr/share/fonts /usr/share/wallpapers
mkdir -p "$SKEL_CONFIG" "$SKEL_LOCAL/plasma"

# 1. Estrazione Temi e Icone in /usr/share (Accessibili a tutti)
unzip -o "${ASSETS_DIR}/plasma6macos-plasma-theme.zip" "aurorae/*" "color-schemes/*" "plasma/*" -d /usr/share/ || true
unzip -o "${ASSETS_DIR}/plasma6macos-gtk-theme.zip" "MacTahoe-*" -d /usr/share/themes/ || true
unzip -o "${ASSETS_DIR}/plasma6macos-icons.zip" "MacTahoe*" -d /usr/share/icons/ || true
unzip -o "${ASSETS_DIR}/plasma6macos-cursors.zip" "WhiteSur-cursors/*" -d /usr/share/icons/ || true
unzip -o "${ASSETS_DIR}/plasma6macos-fonts.zip" -d /usr/share/fonts/ || true
unzip -o "${ASSETS_DIR}/plasma6macos-wallpapers.zip" -d / || true

# 2. Estrazione Configurazioni in /etc/skel (Copia automatica per ogni utente)
# Usiamo || true per evitare l'errore 11 se mancano singoli file opzionali
unzip -o "${ASSETS_DIR}/plasma6macos-kde-config.zip" \
    ".face" ".face.icon" "gtk-3.0/*" "gtk-4.0/*" "xsettingsd/*" \
    "darklyrc" "dolphinrc" "kdeglobals" "kwinrc" "plasmarc" "plasmashellrc" -d /etc/skel/ || true

# Forza il layout specifico per Fedora (uBlue base)
unzip -oj "${ASSETS_DIR}/plasma6macos-kde-config.zip" "fedora/plasma-org.kde.plasma.desktop-appletsrc" -d "$SKEL_CONFIG/" || true

# 3. BONIFICA PERCORSI (Addio "steve"!)
echo "🧹 Pulizia riferimenti a percorsi personali..."
# Rimuoviamo i link simbolici rotti dello ZIP originale che puntano a /home/steve
find /etc/skel -type l -delete

# Ricreiamo i link corretti verso le risorse globali di sistema
mkdir -p "$SKEL_CONFIG/gtk-4.0"
ln -sf /usr/share/themes/MacTahoe-Dark/gtk-4.0/assets "$SKEL_CONFIG/gtk-4.0/assets"
ln -sf /usr/share/themes/MacTahoe-Dark/gtk-4.0/gtk.css "$SKEL_CONFIG/gtk-4.0/gtk.css"
ln -sf /usr/share/themes/MacTahoe-Dark/gtk-4.0/gtk-dark.css "$SKEL_CONFIG/gtk-4.0/gtk-dark.css"

# 4. SDDM (Schermata di Login)
unzip -o "${ASSETS_DIR}/plasma6macos-sddm.zip" "tahoe-sddm/*" "tahoe-sddm-dark/*" -d /usr/share/sddm/themes/ || true

echo "✅ Installazione completata correttamente."
