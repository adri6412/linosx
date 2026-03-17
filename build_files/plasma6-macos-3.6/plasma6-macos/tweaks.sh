#!/bin/bash
# Tweaks modificato per impostare il default globale in /etc/skel

set -euo pipefail

SKEL_CONFIG="/etc/skel/.config"
SKEL_GTK2="/etc/skel/.gtkrc-2.0"

apply_global_dark_default() {
    echo "🌙 Impostazione Dark Theme come default di sistema..."
    
    # Modifica kdeglobals in skel
    mkdir -p "$SKEL_CONFIG"
    
    # Invece di lookandfeeltool (che richiede X11), modifichiamo i file testuali direttamente
    sed -i 's/^theme=.*/theme=MacSequoiaDark/' "$SKEL_CONFIG/Kvantum/kvantum.kvconfig" 2>/dev/null || true
    
    # Configurazione GTK2/3/4 per tutti i nuovi utenti
    echo 'gtk-theme-name="MacTahoe-Dark"' > "$SKEL_GTK2"
    
    mkdir -p "$SKEL_CONFIG/gtk-3.0" "$SKEL_CONFIG/gtk-4.0"
    echo -e "[Settings]\ngtk-theme-name=MacTahoe-Dark" > "$SKEL_CONFIG/gtk-3.0/settings.ini"
    echo -e "[Settings]\ngtk-theme-name=MacTahoe-Dark" > "$SKEL_CONFIG/gtk-4.0/settings.ini"

    # Symlink per LibAdwaita (GTK4) globale
    # Nota: Durante la build del container, i symlink devono essere relativi o puntare a /usr
    ln -sf "/usr/share/themes/MacTahoe-Dark/gtk-4.0/assets" "$SKEL_CONFIG/gtk-4.0/assets"
    ln -sf "/usr/share/themes/MacTahoe-Dark/gtk-4.0/gtk.css" "$SKEL_CONFIG/gtk-4.0/gtk.css"
    ln -sf "/usr/share/themes/MacTahoe-Dark/gtk-4.0/gtk-dark.css" "$SKEL_CONFIG/gtk-4.0/gtk-dark.css"
}

# Esegui l'impostazione
apply_global_dark_default