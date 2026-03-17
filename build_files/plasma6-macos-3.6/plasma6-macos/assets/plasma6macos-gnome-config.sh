#!/bin/bash

# Function to write dconf settings with error handling
write_dconf_setting() {
  local key="$1"
  local value="$2"
  echo "Attempting to write: dconf write $key $value"
  if dconf write "$key" "$value"; then
    echo "Successfully wrote: $key"
  else
    echo "Error writing: $key with value $value"
    exit 1
  fi
}

# org/gnome/Weather
write_dconf_setting /org/gnome/Weather/window-height 407
write_dconf_setting /org/gnome/Weather/window-maximized false
write_dconf_setting /org/gnome/Weather/window-width 498

# org/gnome/desktop/a11y/applications
write_dconf_setting /org/gnome/desktop/a11y/applications/screen-reader-enabled false

# org/gnome/desktop/interface
write_dconf_setting /org/gnome/desktop/interface/color-scheme "'default'"
write_dconf_setting /org/gnome/desktop/interface/cursor-blink true
write_dconf_setting /org/gnome/desktop/interface/cursor-blink-time 1000
write_dconf_setting /org/gnome/desktop/interface/cursor-size 24
write_dconf_setting /org/gnome/desktop/interface/cursor-theme "'WhiteSur-cursors'"
write_dconf_setting /org/gnome/desktop/interface/enable-animations true
write_dconf_setting /org/gnome/desktop/interface/font-name "'SF Pro Display,  10'"
write_dconf_setting /org/gnome/desktop/interface/gtk-theme "'MacTahoe-Dark'"
write_dconf_setting /org/gnome/desktop/interface/icon-theme "'MacTahoe-Dark'"
write_dconf_setting /org/gnome/desktop/interface/scaling-factor "uint32 1"
write_dconf_setting /org/gnome/desktop/interface/text-scaling-factor 1.0
write_dconf_setting /org/gnome/desktop/interface/toolbar-style "'text'"

# org/gnome/desktop/sound
write_dconf_setting /org/gnome/desktop/sound/theme-name "'ocean'"

# org/gnome/desktop/wm/preferences
write_dconf_setting /org/gnome/desktop/wm/preferences/button-layout "'close,minimize,maximize:'"

# org/gnome/evolution-data-server
write_dconf_setting /org/gnome/evolution-data-server/migrated true

# org/gnome/login-screen
# write_dconf_setting /org/gnome/login-screen/enable-fingerprint-authentication true
# write_dconf_setting /org/gnome/login-screen/enable-smartcard-authentication false

# org/gnome/nautilus/preferences
write_dconf_setting /org/gnome/nautilus/preferences/default-folder-viewer "'icon-view'"
write_dconf_setting /org/gnome/nautilus/preferences/migrated-gtk-settings true
write_dconf_setting /org/gnome/nautilus/preferences/search-filter-time-type "'last_modified'"

# org/gnome/nautilus/window-state
write_dconf_setting /org/gnome/nautilus/window-state/initial-size "(890, 550)"

# org/gnome/terminal/legacy/profiles:
write_dconf_setting /org/gnome/terminal/legacy/profiles/default "'e9215816-88ec-413c-9c3c-268d2ba23adc'"
write_dconf_setting /org/gnome/terminal/legacy/profiles/list "['b1dcc9dd-5262-4d8d-a863-c897e6d979b9', 'e9215816-88ec-413c-9c3c-268d2ba23adc']"

# org/gnome/terminal/legacy/profiles:/:e9215816-88ec-413c-9c3c-268d2ba23adc
write_dconf_setting /org/gnome/terminal/legacy/profiles/:e9215816-88ec-413c-9c3c-268d2ba23adc/background-color "'rgb(0,43,54)'"
write_dconf_setting /org/gnome/terminal/legacy/profiles/:e9215816-88ec-413c-9c3c-268d2ba23adc/custom-command "'/bin/zsh'"
write_dconf_setting /org/gnome/terminal/legacy/profiles/:e9215816-88ec-413c-9c3c-268d2ba23adc/font "'FiraCode Nerd Font Mono 10'"
write_dconf_setting /org/gnome/terminal/legacy/profiles/:e9215816-88ec-413c-9c3c-268d2ba23adc/foreground-color "'rgb(131,148,150)'"
write_dconf_setting /org/gnome/terminal/legacy/profiles/:e9215816-88ec-413c-9c3c-268d2ba23adc/use-custom-command true
write_dconf_setting /org/gnome/terminal/legacy/profiles/:e9215816-88ec-413c-9c3c-268d2ba23adc/use-system-font false
write_dconf_setting /org/gnome/terminal/legacy/profiles/:e9215816-88ec-413c-9c3c-268d2ba23adc/use-theme-colors false
write_dconf_setting /org/gnome/terminal/legacy/profiles/:e9215816-88ec-413c-9c3c-268d2ba23adc/visible-name "'zsh-starship'"

# org/gtk/gtk4/settings/file-chooser
write_dconf_setting /org/gtk/gtk4/settings/file-chooser/show-hidden false
write_dconf_setting /org/gtk/gtk4/settings/file-chooser/sort-directories-first false

# Set the default profile (schema: org.gnome.Terminal.ProfilesList)
gsettings set org.gnome.Terminal.ProfilesList default 'e9215816-88ec-413c-9c3c-268d2ba23adc'

# Set the list of available profiles (schema: org.gnome.Terminal.ProfilesList)
gsettings set org.gnome.Terminal.ProfilesList list "['b1dcc9dd-5262-4d8d-a863-c897e6d979b9', 'e9215816-88ec-413c-9c3c-268d2ba23adc']"

# Set individual properties for the 'zsh-starship' profile
# Note the combined schema and dconf path for individual profile settings
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:e9215816-88ec-413c-9c3c-268d2ba23adc/ background-color 'rgb(0,43,54)'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:e9215816-88ec-413c-9c3c-268d2ba23adc/ custom-command '/bin/zsh'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:e9215816-88ec-413c-9c3c-268d2ba23adc/ font 'FiraCode Nerd Font Mono 10'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:e9215816-88ec-413c-9c3c-268d2ba23adc/ foreground-color 'rgb(131,148,150)'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:e9215816-88ec-413c-9c3c-268d2ba23adc/ use-custom-command true
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:e9215816-88ec-413c-9c3c-268d2ba23adc/ use-system-font false
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:e9215816-88ec-413c-9c3c-268d2ba23adc/ use-theme-colors false
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:e9215816-88ec-413c-9c3c-268d2ba23adc/ visible-name 'zsh-starship'

echo "All dconf settings applied successfully."
