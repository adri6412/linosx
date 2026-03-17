#!/bin/bash
# tweaks.sh - Versione Automatica per Container Build

set -euo pipefail

SKEL_CONFIG="/etc/skel/.config"

echo "🎨 Applicazione configurazioni grafiche macOS di default..."

# Configurazione Kvantum (Dark)
mkdir -p "$SKEL_CONFIG/Kvantum"
echo -e "[General]\ntheme=MacSequoiaDark" > "$SKEL_CONFIG/Kvantum/kvantum.kvconfig"

# Configurazione GTK 3/4 Globale
mkdir -p "$SKEL_CONFIG/gtk-3.0" "$SKEL_CONFIG/gtk-4.0"
echo -e "[Settings]\ngtk-theme-name=MacTahoe-Dark\ngtk-application-prefer-dark-theme=1" > "$SKEL_CONFIG/gtk-3.0/settings.ini"
echo -e "[Settings]\ngtk-theme-name=MacTahoe-Dark\ngtk-application-prefer-dark-theme=1" > "$SKEL_CONFIG/gtk-4.0/settings.ini"

# Disabilitazione Splash Screen (velocizza il login)
mkdir -p "$SKEL_CONFIG"
echo -e "[KSplash]\nEngine=none\nTheme=None" > "$SKEL_CONFIG/ksplashrc"

echo "✅ Tweaks applicati con successo a /etc/skel"
