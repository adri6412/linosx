#!/bin/bash
set -uo pipefail

readonly BASE_PATH="/ctx/plasma6-macos-3.6/plasma6-macos"
readonly ASSETS_DIR="${BASE_PATH}/assets"
readonly SKEL_CONFIG="/etc/skel/.config"

echo "6799;🚀 FIX DEFINITIVO: SDDM e Navbar..."

# --- 1. SDDM (Schermata di Login) ---
echo "🖥️ Configurazione SDDM..."
mkdir -p /usr/share/sddm/themes
unzip -o "${ASSETS_DIR}/plasma6macos-sddm.zip" -d /usr/share/sddm/themes/ || true

# ATTIVAZIONE SDDM: Crea il file di configurazione per forzare il tema
# Sostituisci 'tahoe-sddm' con il nome esatto della cartella estratta se diverso
mkdir -p /etc/sddm.conf.d
cat <<EOF > /etc/sddm.conf.d/theme.conf
[Theme]
Current=tahoe-sddm
EOF

# --- 2. PLASMOIDI (Le barre/navbar) ---
echo "🧩 Installazione Plasmoidi di sistema..."
mkdir -p /usr/share/plasma/plasmoids
# Estraiamo i plasmoidi assicurandoci che non ci siano sottocartelle di troppo
unzip -o "${ASSETS_DIR}/plasma6macos-plasmoids.zip" -d /tmp/plasmoids_temp || true
cp -r /tmp/plasmoids_temp/plasmoids/* /usr/share/plasma/plasmoids/ 2>/dev/null || true
rm -rf /tmp/plasmoids_temp

# --- 3. FIX LAYOUT (Appletsrc) ---
echo "⚙️ Sanitizzazione Layout Navbar..."
mkdir -p "$SKEL_CONFIG"
unzip -o "${ASSETS_DIR}/plasma6macos-kde-config.zip" -d /etc/skel/ || true

# Copia forzata del file layout
if [ -f "/etc/skel/.config/plasma-org.kde.plasma.desktop-appletsrc" ]; then
    cp /etc/skel/.config/plasma-org.kde.plasma.desktop-appletsrc "$SKEL_CONFIG/"
fi

# PULIZIA TOTALE DEI PERCORSI: Trasformiamo /home/steve in percorsi relativi
# Questo è il motivo per cui non vedi le barre: cercano file che non esistono.
find /etc/skel/.config -type f -name "plasma*" -exec sed -i 's|/home/steve/.local/share/plasma/plasmoids/|/usr/share/plasma/plasmoids/|g' {} +
find /etc/skel/.config -type f -exec sed -i 's|/home/steve/|/etc/skel/|g' {} +

# --- 4. TEMA FINESTRE E FINESTRATURE ---
echo "🖼️ Forzatura Motore Aurorae..."
dnf install -y kwin-decorations-aurorae || true

# --- 5. PERMESSI E PULIZIA ---
echo "🔐 Fix permessi finali..."
chmod -R 755 /usr/share/sddm/themes
chmod -R 755 /usr/share/plasma/plasmoids
find /etc/skel -type l -delete # Rimuove link simbolici rotti dello sviluppatore

echo "✅ Fatto. Crea un NUOVO UTENTE per testare (quello vecchio è 'sporco')."
