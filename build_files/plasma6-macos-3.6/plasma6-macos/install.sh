#!/bin/bash
# install.sh - Installazione completa: Dipendenze + Temi + Fix per uBlue
set -uo pipefail

# Percorsi dinamici per la build
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly ASSETS_DIR="${SCRIPT_DIR}/assets"
readonly SKEL_CONFIG="/etc/skel/.config"

echo "🚀 Inizio installazione totale macOS Style..."

# --- 1. INSTALLAZIONE PACCHETTI (Dallo script originale) ---
echo "📦 Installazione dipendenze di sistema (Fedora/Aurora)..."

# Lista consolidata dalle variabili originali: DEPENDENCIES + GNOME_APPS + KVANTUM + SHELL
dnf install -y \
    qt5-qttools kate curl wget rsync git dconf sassc unzip zip \
    nautilus gnome-terminal-nautilus gnome-weather gnome-maps gnome-calendar gnome-clocks vlc \
    fastfetch cava kvantum flatpak fuse zsh util-linux-user \
    ImageMagick

# Installazione Starship (Prompt Zsh)
echo "⭐ Installazione Starship..."
curl -sS https://starship.rs/install.sh | sh -s -- --yes

# --- 2. ESTRAZIONE ASSET (Temi, Icone, Font) ---
echo "🎨 Estrazione Temi e Icone in /usr/share..."
mkdir -p /usr/share/themes /usr/share/icons /usr/share/fonts /usr/share/wallpapers

unzip -o "${ASSETS_DIR}/plasma6macos-plasma-theme.zip" "aurorae/*" "color-schemes/*" "plasma/*" -d /usr/share/ || true
unzip -o "${ASSETS_DIR}/plasma6macos-gtk-theme.zip" "MacTahoe-*" -d /usr/share/themes/ || true
unzip -o "${ASSETS_DIR}/plasma6macos-icons.zip" "MacTahoe*" -d /usr/share/icons/ || true
unzip -o "${ASSETS_DIR}/plasma6macos-cursors.zip" "WhiteSur-cursors/*" -d /usr/share/icons/ || true
unzip -o "${ASSETS_DIR}/plasma6macos-fonts.zip" -d /usr/share/fonts/ || true
unzip -o "${ASSETS_DIR}/plasma6macos-wallpapers.zip" -d / || true

# --- 3. CONFIGURAZIONI UTENTE (Skel) ---
echo "⚙️ Preparazione configurazioni /etc/skel..."
mkdir -p "$SKEL_CONFIG"

unzip -o "${ASSETS_DIR}/plasma6macos-kde-config.zip" \
    ".face" ".face.icon" "gtk-3.0/*" "gtk-4.0/*" "xsettingsd/*" \
    "darklyrc" "dolphinrc" "kdeglobals" "kwinrc" "plasmarc" "plasmashellrc" -d /etc/skel/ || true

# Layout specifico per Fedora/Aurora
unzip -oj "${ASSETS_DIR}/plasma6macos-kde-config.zip" "fedora/plasma-org.kde.plasma.desktop-appletsrc" -d "$SKEL_CONFIG/" || true

# --- 4. BONIFICA PERCORSI (Fix "Steve" & Symlinks) ---
echo "🧹 Eliminazione link simbolici rotti e riferimenti personali..."
# Rimuove i link che puntavano a /home/steve nello zip originale
find /etc/skel -type l -delete

# Crea link universali verso le cartelle di sistema
mkdir -p "$SKEL_CONFIG/gtk-4.0"
ln -sf /usr/share/themes/MacTahoe-Dark/gtk-4.0/assets "$SKEL_CONFIG/gtk-4.0/assets"
ln -sf /usr/share/themes/MacTahoe-Dark/gtk-4.0/gtk.css "$SKEL_CONFIG/gtk-4.0/gtk.css"
ln -sf /usr/share/themes/MacTahoe-Dark/gtk-4.0/gtk-dark.css "$SKEL_CONFIG/gtk-4.0/gtk-dark.css"

# --- 5. SDDM (Login Screen) ---
unzip -o "${ASSETS_DIR}/plasma6macos-sddm.zip" "tahoe-sddm/*" "tahoe-sddm-dark/*" -d /usr/share/sddm/themes/ || true

# Pulizia finale DNF
dnf clean all

echo "✅ Tutto installato e configurato globalmente!"
