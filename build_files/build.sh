#!/bin/bash

# Rende lo script rigoroso: si ferma se c'è un errore critico
set -ouex pipefail

### Install packages

# Questo installa tmux (dal tuo script originale)
dnf5 install -y tmux 

# 1. Installazione di COSMIC Desktop
# Installiamo il desktop e il suo display manager (greeter) nativo per Wayland.
echo "Installazione COSMIC Desktop..."
dnf5 install -y cosmic-desktop cosmic-greeter

# 2. Rimozione Desktop Environment esistente (KDE)
# Ora rimuoviamo KDE in sicurezza, dato che COSMIC è già al suo posto.
echo "Rimozione KDE in corso..."
dnf5 remove -y \
    plasma-desktop \
    plasma-workspace \
    kwin \
    konsole \
    dolphin \
    --setopt=protected_packages= || true

# 3. Configurazione del sistema grafico (Wayland)
echo "Configurazione dei servizi di avvio..."

# Disabilitiamo i vecchi login manager nel caso siano sopravvissuti (SDDM per KDE, GDM per GNOME)
systemctl disable sddm.service || true
systemctl disable gdm.service || true

# Abilitiamo il login manager di COSMIC
systemctl enable cosmic-greeter.service

# Forziamo il sistema ad avviarsi in modalità grafica
systemctl set-default graphical.target

# 4. Pulizia per ridurre il peso del layer dell'immagine
echo "Pulizia cache..."
dnf5 clean all
rm -rf /var/cache/dnf5
rm -rf /var/cache/dnf

echo "--- Build dello strato personalizzato completata ---"
