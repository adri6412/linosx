#!/bin/bash
set -uo pipefail

readonly BASE_PATH="/ctx/plasma6-macos-3.6/plasma6-macos"
readonly ASSETS_DIR="${BASE_PATH}/assets"
readonly SKEL_CONFIG="/etc/skel/.config"

echo "6799;🛠️ Fix Visibilità Temi e Permessi..."

# --- 1. PREPARAZIONE DIRECTORY DI SISTEMA ---
# Assicuriamoci che i percorsi siano quelli standard di KDE Plasma 6
mkdir -p /usr/share/themes \
         /usr/share/icons \
         /usr/share/fonts \
         /usr/share/aurorae/themes \
         /usr/share/plasma/desktoptheme \
         /usr/share/plasma/look-and-feel \
         /usr/share/plasma/plasmoids \
         /usr/share/Kvantum \
         /usr/share/wallpapers

# --- 2. ESTRAZIONE MIRATA ---
# Usiamo -j (junk paths) dove necessario o verifichiamo la struttura
echo "📦 Estrazione Asset..."

unzip -o "${ASSETS_DIR}/plasma6macos-plasma-theme.zip" "aurorae/*" -d /usr/share/ || true
unzip -o "${ASSETS_DIR}/plasma6macos-plasma-theme.zip" "plasma/desktoptheme/*" -d /usr/share/ || true
unzip -o "${ASSETS_DIR}/plasma6macos-plasma-theme.zip" "plasma/look-and-feel/*" -d /usr/share/ || true

unzip -o "${ASSETS_DIR}/plasma6macos-gtk-theme.zip" -d /usr/share/themes/ || true
unzip -o "${ASSETS_DIR}/plasma6macos-icons.zip" -d /usr/share/icons/ || true
unzip -o "${ASSETS_DIR}/plasma6macos-fonts.zip" -d /usr/share/fonts/ || true
unzip -o "${ASSETS_DIR}/plasma6macos-wallpapers.zip" -d / || true
unzip -o "${ASSETS_DIR}/plasma6macos-plasmoids.zip" "plasmoids/*" -d /usr/share/plasma/ || true

# --- 3. IL FIX DEI PERMESSI (Fondamentale per uBlue) ---
# Se i file estratti hanno permessi restrittivi, l'utente non li vedrà mai
echo "🔐 Normalizzazione permessi in /usr/share..."
find /usr/share/themes /usr/share/icons /usr/share/fonts /usr/share/plasma /usr/share/aurorae -type d -exec chmod 755 {} +
find /usr/share/themes /usr/share/icons /usr/share/fonts /usr/share/plasma /usr/share/aurorae -type f -exec chmod 644 {} +

# --- 4. CONFIGURAZIONE /ETC/SKEL ---
echo "⚙️ Preparazione configurazioni utente..."
mkdir -p "$SKEL_CONFIG"
unzip -o "${ASSETS_DIR}/plasma6macos-kde-config.zip" -d /etc/skel/ || true

# Bonifica percorsi "Steve" nei file di testo
find /etc/skel/.config -type f -exec sed -i 's|/home/steve/|/etc/skel/|g' {} +
# Se l'utente esiste già, cercherà comunque i file in .local, forziamo il sistema:
find /etc/skel/.config -type f -exec sed -i 's|/etc/skel/.local/share/|/usr/share/|g' {} +

# --- 5. FORZATURA TEMA GLOBALE ---
# Scriviamo direttamente nel kdeglobals dello skeleton quale tema caricare
cat <<EOF >> /etc/skel/.config/kdeglobals
[KDE]
LookAndFeelPackage=com.github.vinceliuice.MacSequoia-Dark
EOF

echo "✅ Script terminato. Ora i temi sono leggibili da ogni utente."
