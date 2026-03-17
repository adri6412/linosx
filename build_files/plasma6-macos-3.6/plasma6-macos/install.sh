#!/bin/bash
# install.sh - Installazione completa: Pacchetti + Asset + Tweaks + Fix uBlue
set -uo pipefail

# Percorsi dinamici
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly ASSETS_DIR="${SCRIPT_DIR}/assets"
readonly SKEL_CONFIG="/etc/skel/.config"
readonly SKEL_LOCAL="/etc/skel/.local/share"

echo "🚀 AVVIO INSTALLAZIONE TOTALE MAC-OS THEME (System-wide)..."

# --- 1. INSTALLAZIONE DIPENDENZE (Tutti i pacchetti originali) ---
echo "📦 Installazione pacchetti di sistema..."
dnf install -y \
    qt5-qttools kate curl wget rsync git dconf sassc unzip zip \
    nautilus gnome-terminal-nautilus gnome-weather gnome-maps gnome-calendar gnome-clocks vlc \
    fastfetch cava kvantum flatpak fuse zsh util-linux-user \
    ImageMagick

# Starship Prompt per la shell
curl -sS https://starship.rs/install.sh | sh -s -- --yes

# --- 2. ESTRAZIONE ASSET GLOBALI (/usr/share) ---
echo "🎨 Estrazione Temi, Icone e Motori grafici..."
mkdir -p /usr/share/themes /usr/share/icons /usr/share/fonts /usr/share/wallpapers /usr/share/Kvantum

# Temi Plasma e Look-and-Feel
unzip -o "${ASSETS_DIR}/plasma6macos-plasma-theme.zip" "aurorae/*" "color-schemes/*" "plasma/*" -d /usr/share/ || true

# Tema GTK (Fondamentale per app non-KDE)
unzip -o "${ASSETS_DIR}/plasma6macos-gtk-theme.zip" "MacTahoe-*" -d /usr/share/themes/ || true

# Icone e Cursori
unzip -o "${ASSETS_DIR}/plasma6macos-icons.zip" "MacTahoe*" -d /usr/share/icons/ || true
unzip -o "${ASSETS_DIR}/plasma6macos-cursors.zip" "WhiteSur-cursors/*" -d /usr/share/icons/ || true

# Font e Sfondi
unzip -o "${ASSETS_DIR}/plasma6macos-fonts.zip" -d /usr/share/fonts/ || true
unzip -o "${ASSETS_DIR}/plasma6macos-wallpapers.zip" -d / || true

# Plasmoidi e Effetti KWin
unzip -o "${ASSETS_DIR}/plasma6macos-plasmoids.zip" "plasmoids/*" -d /usr/share/plasma/ || true
unzip -o "${ASSETS_DIR}/plasma6macos-kwin-effect.zip" "kwin/*" -d /usr/share/ || true

# SDDM
unzip -o "${ASSETS_DIR}/plasma6macos-sddm.zip" "tahoe-sddm/*" "tahoe-sddm-dark/*" -d /usr/share/sddm/themes/ || true

# --- 3. CONFIGURAZIONE DEFAULT UTENTE (/etc/skel) ---
echo "⚙️ Configurazione ambiente predefinito (Skeleton)..."
mkdir -p "$SKEL_CONFIG" "$SKEL_LOCAL/plasma"

# Estrazione file config
unzip -o "${ASSETS_DIR}/plasma6macos-kde-config.zip" \
    ".face" ".face.icon" "gtk-3.0/*" "gtk-4.0/*" "xsettingsd/*" \
    "darklyrc" "dolphinrc" "kdeglobals" "kwinrc" "plasmarc" "plasmashellrc" -d /etc/skel/ || true

# Layout Pannello/Dock specifico Fedora
unzip -oj "${ASSETS_DIR}/plasma6macos-kde-config.zip" "fedora/plasma-org.kde.plasma.desktop-appletsrc" -d "$SKEL_CONFIG/" || true

# --- 4. TWEAKS E ATTIVAZIONE MOTORE KVANTUM (Il cuore del tema) ---
echo "🌙 Impostazione Dark Mode e Kvantum..."

# Forza Kvantum a usare il tema Mac
mkdir -p "$SKEL_CONFIG/Kvantum"
echo -e "[General]\ntheme=MacSequoiaDark" > "$SKEL_CONFIG/Kvantum/kvantum.kvconfig"

# Configurazione GTK 3/4 per LibAdwaita
cat <<EOF > "$SKEL_CONFIG/gtk-3.0/settings.ini"
[Settings]
gtk-theme-name=MacTahoe-Dark
gtk-application-prefer-dark-theme=1
EOF
cp "$SKEL_CONFIG/gtk-3.0/settings.ini" "$SKEL_CONFIG/gtk-4.0/settings.ini"

# Disabilita Splash Screen
echo -e "[KSplash]\nEngine=none\nTheme=None" > "$SKEL_CONFIG/ksplashrc"

# --- 5. BONIFICA FINALE (Fix percorsi e "Steve") ---
echo "🧹 Bonifica link simbolici..."
# Elimina i link "marci" che puntano alla home dello sviluppatore originale
find /etc/skel -type l -delete

# Ricrea i link corretti verso il sistema per GTK4
ln -sf /usr/share/themes/MacTahoe-Dark/gtk-4.0/assets "$SKEL_CONFIG/gtk-4.0/assets"
ln -sf /usr/share/themes/MacTahoe-Dark/gtk-4.0/gtk.css "$SKEL_CONFIG/gtk-4.0/gtk.css"
ln -sf /usr/share/themes/MacTahoe-Dark/gtk-4.0/gtk-dark.css "$SKEL_CONFIG/gtk-4.0/gtk-dark.css"

# Pulizia cache DNF
dnf clean all

echo "✅ INSTALLAZIONE COMPLETATA CON SUCCESSO!"
