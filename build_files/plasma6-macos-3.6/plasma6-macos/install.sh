#!/bin/bash
set -uo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly ASSETS_DIR="${SCRIPT_DIR}/assets"
readonly SKEL_CONFIG="/etc/skel/.config"
readonly SKEL_LOCAL="/etc/skel/.local/share"

echo "🚀 INSTALLAZIONE TOTALE MAC-OS (Fix Navbar + Finestre)..."

# 1. PACCHETTI (Motori grafici indispensabili)
dnf install -y \
    qt5-qttools rsync git dconf sassc unzip zip \
    kvantum kwin-decorations-aurorae plasma-wayland-protocols \
    fastfetch cava zsh util-linux-user ImageMagick

# 2. ESTRAZIONE ASSETS NEI PERCORSI DI SISTEMA (/usr/share)
# Nota: Aurorae (temi finestre) deve andare in /usr/share/aurorae/themes/
mkdir -p /usr/share/themes /usr/share/icons /usr/share/fonts /usr/share/aurorae/themes /usr/share/plasma/plasmoids /usr/share/Kvantum

echo "📦 Estrazione Temi Finestre (Aurorae)..."
unzip -o "${ASSETS_DIR}/plasma6macos-plasma-theme.zip" "aurorae/*" -d /usr/share/ || true

echo "📦 Estrazione Plasmoidi (per la Navbar sotto)..."
unzip -o "${ASSETS_DIR}/plasma6macos-plasmoids.zip" "plasmoids/*" -d /usr/share/plasma/ || true

echo "📦 Estrazione Temi e Icone..."
unzip -o "${ASSETS_DIR}/plasma6macos-gtk-theme.zip" "MacTahoe-*" -d /usr/share/themes/ || true
unzip -o "${ASSETS_DIR}/plasma6macos-icons.zip" "MacTahoe*" -d /usr/share/icons/ || true
unzip -o "${ASSETS_DIR}/plasma6macos-fonts.zip" -d /usr/share/fonts/ || true
unzip -o "${ASSETS_DIR}/plasma6macos-wallpapers.zip" -d / || true

# 3. CONFIGURAZIONE LAYOUT (La Navbar sotto)
echo "⚙️ Configurazione Navbar e Desktop..."
mkdir -p "$SKEL_CONFIG"

# Estraiamo tutte le config di KDE
unzip -o "${ASSETS_DIR}/plasma6macos-kde-config.zip" -d /etc/skel/ || true

# FIX CRUCIALE: Forza il file del layout (appletsrc) nella posizione corretta
# Senza questo, la navbar sotto non apparirà MAI.
cp /etc/skel/.config/plasma-org.kde.plasma.desktop-appletsrc "$SKEL_CONFIG/" 2>/dev/null || true
# Se esiste una versione specifica per Fedora nello zip, usiamola
unzip -oj "${ASSETS_DIR}/plasma6macos-kde-config.zip" "fedora/plasma-org.kde.plasma.desktop-appletsrc" -d "$SKEL_CONFIG/" || true

# 4. FIX TEMA FINESTRE (KWin + Aurorae)
echo "🖼️ Forzatura tema finestre..."
# Modifichiamo il kwinrc nello skeleton per usare il tema Apple estratto
cat <<EOF >> "$SKEL_CONFIG/kwinrc"

[org.kde.kdecoration2]
ButtonsOnLeft=XIA
ButtonsOnRight=
CloseOnDoubleClickOnMenu=false
library=org.kde.kwin.aurorae
theme=__aurorae__svg__MacSequoiaDark
EOF

# 5. FIX KVANTUM (Trasparenze finestre)
mkdir -p "$SKEL_CONFIG/Kvantum"
echo -e "[General]\ntheme=MacSequoiaDark" > "$SKEL_CONFIG/Kvantum/kvantum.kvconfig"

# 6. BONIFICA FINALE (Pulizia percorsi "Steve")
find /etc/skel -type l -delete
# Ricreiamo i link per GTK4 verso il sistema
mkdir -p "$SKEL_CONFIG/gtk-4.0"
ln -sf /usr/share/themes/MacTahoe-Dark/gtk-4.0/assets "$SKEL_CONFIG/gtk-4.0/assets"
ln -sf /usr/share/themes/MacTahoe-Dark/gtk-4.0/gtk.css "$SKEL_CONFIG/gtk-4.0/gtk.css"
ln -sf /usr/share/themes/MacTahoe-Dark/gtk-4.0/gtk-dark.css "$SKEL_CONFIG/gtk-4.0/gtk-dark.css"
# --- 6. SANITIZZAZIONE CONFIGURAZIONI (Indispensabile per nuovi utenti) ---
echo "🧹 Sanitizzazione profonda dei file di configurazione in /etc/skel..."

# Sostituiamo ogni occorrenza di /home/steve con un segnaposto variabile o con il percorso di sistema
# KDE supporta l'espansione di alcune variabili, ma la cosa più sicura è puntare alle risorse globali
find /etc/skel/.config -type f -exec sed -i 's|/home/steve/.local/share/|/usr/share/|g' {} +
find /etc/skel/.config -type f -exec sed -i 's|/home/steve/|/etc/skel/|g' {} +

# Forza la ricarica del tema globale nel file kdeglobals
# Assicuriamoci che il nome del tema sia esattamente quello presente in /usr/share/plasma/look-and-feel/
if [ -f "/etc/skel/.config/kdeglobals" ]; then
    sed -i 's/^LookAndFeelPackage=.*/LookAndFeelPackage=com.github.vinceliuice.MacSequoia-Dark/' /etc/skel/.config/kdeglobals
fi

dnf clean all
echo "✅ Installazione completata. La Navbar e il tema finestre sono ora configurati come default."
