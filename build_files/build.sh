#!/bin/bash

# Rende lo script rigoroso: si ferma se c'è un errore critico
set -ouex pipefail

### Install packages

# Questo installa tmux (dal tuo script originale)
dnf5 install -y tmux 

# 1. Installazione del nuovo Desktop e del Display Manager
# Installiamo Budgie e LightDM PRIMA di rimuovere KDE, 
# per assicurarci che lo stack grafico rimanga intatto.
echo "Installazione Budgie Desktop e LightDM..."
dnf5 install -y @budgie-desktop lightdm lightdm-gtk

# 2. Rimozione Desktop Environment esistente (KDE)
# Ora possiamo rimuovere KDE in sicurezza.
echo "Rimozione KDE in corso..."
dnf5 remove -y \
    plasma-desktop \
    plasma-workspace \
    kwin \
    konsole \
    dolphin \
    --setopt=protected_packages= || true

# 3. Configurazione del sistema grafico (IL PASSAGGIO CHIAVE)
# Disabilitiamo il vecchio login manager di KDE (se è sopravvissuto)
systemctl disable sddm.service || true
# Abilitiamo LightDM per avere la schermata di login grafico
systemctl enable lightdm.service

# Forziamo il sistema ad avviarsi in modalità grafica e non testuale
systemctl set-default graphical.target

# 4. Pulizia per ridurre il peso del layer dell'immagine
echo "Pulizia cache..."
dnf5 clean all
rm -rf /var/cache/dnf5
rm -rf /var/cache/dnf

echo "--- Build dello strato personalizzato completata ---"
