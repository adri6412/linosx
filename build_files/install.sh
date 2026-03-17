#!/bin/bash
set -e

echo "--- Inizio configurazione ambiente Pantheon ---"

# 1. Pulizia dei pacchetti GNOME esistenti
# In un container, dnf remove è più rapido di rpm-ostree
echo "Rimozione dei componenti GNOME..."
dnf remove -y \
    gnome-shell \
    gnome-session \
    nautilus \
    mutter \
    --nodeps

# 2. Installazione del Desktop Environment Pantheon
# Il gruppo 'pantheon-desktop' contiene tutto il necessario per elementary OS
echo "Installazione di Pantheon..."
dnf install -y \
    @pantheon-desktop \
    pantheon-session-settings \
    lightdm-pantheon-greeter \
    wingpanel \
    plank

# 3. Pulizia della cache per ridurre la dimensione dell'immagine
echo "Pulizia post-installazione..."
dnf clean all
rm -rf /var/cache/dnf

echo "--- Installazione completata ---"
