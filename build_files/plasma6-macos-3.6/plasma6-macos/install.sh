#!/bin/bash
set -uo pipefail

# Percorsi assoluti dentro il container durante la build
# Dato che monti build_files in /ctx, il percorso diventa questo:
readonly BASE_PATH="/ctx/plasma6-macos-3.6/plasma6-macos"
readonly ASSETS_DIR="${BASE_PATH}/assets"
readonly SKEL_CONFIG="/etc/skel/.config"

echo "6799;🔍 Verifico presenza file in: ${ASSETS_DIR}"

# --- 1. PRE-REQUISITI ---
# Forza l'installazione di unzip prima di ogni altra cosa
dnf install -y unzip zip || true

# --- 2. CONTROLLO ASSETS ---
if [ ! -d "$ASSETS_DIR" ]; then
    echo "❌ ERRORE: La cartella assets non esiste in ${ASSETS_DIR}"
    ls -R /ctx # Debug per vedere cosa c'è effettivamente nel mount
    exit 1
fi

# --- 3. ESTRAZIONE (Con percorsi forzati) ---
echo "📦 Estrazione componenti sistema..."
mkdir -p /usr/share/themes /usr/share/icons /usr/share/fonts /usr/share/aurorae/themes /usr/share/plasma/plasmoids

# Estrazione temi e icone
unzip -o "${ASSETS_DIR}/plasma6macos-plasma-theme.zip" "aurorae/*" -d /usr/share/ || echo "Salto plasma-theme"
unzip -o "${ASSETS_DIR}/plasma6macos-gtk-theme.zip" -d /usr/share/themes/ || echo "Salto gtk-theme"
unzip -o "${ASSETS_DIR}/plasma6macos-icons.zip" -d /usr/share/icons/ || echo "Salto icons"
unzip -o "${ASSETS_DIR}/plasma6macos-fonts.zip" -d /usr/share/fonts/ || echo "Salto fonts"
unzip -o "${ASSETS_DIR}/plasma6macos-wallpapers.zip" -d / || echo "Salto wallpapers"
unzip -o "${ASSETS_DIR}/plasma6macos-plasmoids.zip" "plasmoids/*" -d /usr/share/plasma/ || echo "Salto plasmoids"

# --- 4. CONFIGURAZIONE DEFAULT (/etc/skel) ---
echo "⚙️ Configurazione default utente in /etc/skel..."
mkdir -p "$SKEL_CONFIG"

# Estrai le config KDE
unzip -o "${ASSETS_DIR}/plasma6macos-kde-config.zip" -d /etc/skel/ || echo "Salto kde-configs"

# Fix specifico per il layout della Navbar (fondamentale per uBlue)
if [ -f "/etc/skel/.config/plasma-org.kde.plasma.desktop-appletsrc" ]; then
    cp /etc/skel/.config/plasma-org.kde.plasma.desktop-appletsrc "$SKEL_CONFIG/"
fi

# --- 5. TWEAKS (Integrati) ---
echo "🌙 Applicazione Kvantum e Dark Mode..."
mkdir -p "$SKEL_CONFIG/Kvantum"
echo -e "[General]\ntheme=MacSequoiaDark" > "$SKEL_CONFIG/Kvantum/kvantum.kvconfig"

# --- 6. PULIZIA PERCORSI "STEVE" ---
# Elimina i link rotti che puntano alla home originale dello sviluppatore
find /etc/skel -type l -delete

# Sostituzione testuale dei percorsi hardcoded nei file config
find /etc/skel/.config -type f -exec sed -i 's|/home/steve/|/etc/skel/|g' {} +

echo "✅ Installazione completata correttamente!"
