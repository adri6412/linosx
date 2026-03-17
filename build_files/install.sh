#!/bin/bash

# 1. Rimuovere i gruppi di pacchetti GNOME (ambiente di default di Bluefin)
echo "Rimozione dell'ambiente desktop GNOME in corso..."
# Nota: Su sistemi Atomic, spesso è meglio fare il 'rebase' o l'override
rpm-ostree override remove \
    gnome-shell \
    nautilus \
    gnome-terminal-nautilus \
    --required

# 2. Aggiungere i repository necessari (se richiesti) e installare Pantheon
echo "Installazione di Pantheon Desktop..."
# Pantheon su Fedora è disponibile tramite i gruppi di pacchetti
rpm-ostree install \
    pantheon-session-settings \
    pantheon-desktop \
    gala \
    wingpanel \
    plank \
    switchboard

# 3. Impostare il target grafico
systemctl set-default graphical.target

echo "Procedura completata. Ricorda che le modifiche rpm-ostree richiedono un riavvio per essere effettive."
