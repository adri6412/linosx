#!/bin/bash
set -uo pipefail

readonly BASE_PATH="/ctx/plasma6-macos-3.6/plasma6-macos"
readonly ASSETS_DIR="${BASE_PATH}/assets"
readonly SKEL_CONFIG="/etc/skel/.config"

echo "6799;🔍 Analisi e installazione intelligente degli asset..."

# Funzione per installare correttamente un componente cercando il file identificativo
smart_install() {
    local zip_file=$1
    local target_dir=$2
    local search_file=$3 # es. metadata.desktop o index.theme

    echo "📦 Elaborazione $zip_file..."
    mkdir -p /tmp/extract_work
    unzip -o "$zip_file" -d /tmp/extract_work > /dev/null

    # Cerchiamo dove si trova il file identificativo
    find /tmp/extract_work -name "$search_file" | while read -r file; do
        local dir_to_copy=$(dirname "$file")
        cp -r "$dir_to_copy" "$target_dir/"
        echo "✅ Installato $(basename "$dir_to_copy") in $target_dir"
    done
    rm -rf /tmp/extract_work
}

# --- 1. INSTALLAZIONE COMPONENTI ---
mkdir -p /usr/share/sddm/themes /usr/share/plasma/plasmoids /usr/share/icons /usr/share/themes /usr/share/aurorae/themes

# SDDM
smart_install "${ASSETS_DIR}/plasma6macos-sddm.zip" "/usr/share/sddm/themes" "metadata.desktop"

# PLASMOIDI (Navbar)
# Usa metadata.json per i plasmoidi moderni
smart_install "${ASSETS_DIR}/plasma6macos-plasmoids.zip" "/usr/share/plasma/plasmoids" "metadata.json"
smart_install "${ASSETS_DIR}/plasma6macos-plasmoids.zip" "/usr/share/plasma/plasmoids" "metadata.desktop"

# ICONE E CURSORI
smart_install "${ASSETS_DIR}/plasma6macos-icons.zip" "/usr/share/icons" "index.theme"
smart_install "${ASSETS_DIR}/plasma6macos-cursors.zip" "/usr/share/icons" "index.theme"

# TEMI FINESTRE (Aurorae)
smart_install "${ASSETS_DIR}/plasma6macos-plasma-theme.zip" "/usr/share/aurorae/themes" "*.svg"

# --- 2. ATTIVAZIONE SDDM ---
# Troviamo il primo tema SDDM utile per il file di configurazione
SDDM_THEME=$(ls /usr/share/sddm/themes | head -n 1)
if [ -z "$SDDM_THEME" ]; then
    echo "⚠️ SDDM: Nessuna cartella trovata!"
else
    echo "🖥️ Attivazione SDDM: $SDDM_THEME"
    mkdir -p /etc/sddm.conf.d
    echo -e "[Theme]\nCurrent=$SDDM_THEME" > /etc/sddm.conf.d/theme.conf
fi

# --- 3. CONFIGURAZIONE LAYOUT E NAVBAR ---
echo "⚙️ Configurazione Navbar..."
mkdir -p "$SKEL_CONFIG"
unzip -o "${ASSETS_DIR}/plasma6macos-kde-config.zip" -d /etc/skel/ > /dev/null || true

# Trasformiamo i percorsi di 'steve' in percorsi universali
find /etc/skel/.config -type f -exec sed -i "s|/home/steve/.local/share/plasma/plasmoids/|/usr/share/plasma/plasmoids/|g" {} +
find /etc/skel/.config -type f -exec sed -i "s|/home/steve/|/etc/skel/|g" {} +

# --- 4. PERMESSI (Fondamentale per uBlue) ---
echo "🔐 Fix permessi globali..."
chmod -R 755 /usr/share/sddm/themes /usr/share/plasma/plasmoids /usr/share/icons /usr/share/themes
find /usr/share/ -type f \( -name "*.desktop" -o -name "index.theme" -o -name "*.conf" \) -exec chmod 644 {} +

dnf clean all
echo "✅ Installazione completata."
