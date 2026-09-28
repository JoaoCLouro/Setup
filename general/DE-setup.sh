#!/bin/bash 

# Fetches the orchis theme git repo
cd ~/Downloads
git clone https://github.com/vinceliuice/orchis-theme
cd orchis-theme

# Install the theme with specific options
./install.sh -c dark -l --tweaks compact black macos

# 1. Install CLI tools if missing
if ! command -v gnome-extensions-cli &> /dev/null; then
    yay -S --noconfirm gnome-extensions-cli
fi

# 2. Install Extensions
EXTENSIONS=(
    "blur-my-shell@aunetx"
    "dash-to-dock@micxgx.gmail.com"
    "user-theme@gnome-shell-extensions.gcampax.github.com"
    "Vitals@CoreCoding.com"
)

for uuid in "${EXTENSIONS[@]}"; do
    gnome-extensions-cli install "$uuid"
    gnome-extensions enable "$uuid"
done

# 3. Compile Blur my Shell schemas locally so gsettings can access them immediately
BMS_SCHEMA_DIR="$HOME/.local/share/gnome-shell/extensions/blur-my-shell@aunetx/schemas"
if [ -d "$BMS_SCHEMA_DIR" ]; then
    glib-compile-schemas "$BMS_SCHEMA_DIR"
    export GSETTINGS_SCHEMA_DIR="$BMS_SCHEMA_DIR"
fi

# 4. Apply Blur my Shell Configurations

# Panel Settings
gsettings set org.gnome.shell.extensions.blur-my-shell.panel override-background true 
gsettings set org.gnome.shell.extensions.blur-my-shell.panel disable-in-overview true 
gsettings set org.gnome.shell.extensions.blur-my-shell.panel blur-dash-to-panel true 

# Overview & App Folders
gsettings set org.gnome.shell.extensions.blur-my-shell.overview style-components 'light'
gsettings set org.gnome.shell.extensions.blur-my-shell.appfolder blur true 
gsettings set org.gnome.shell.extensions.blur-my-shell.appfolder sigma 30 
gsettings set org.gnome.shell.extensions.blur-my-shell.appfolder brightness 0.60 
gsettings set org.gnome.shell.extensions.blur-my-shell.appfolder style-dialogs 'transparent'

# Dash to Dock Blur
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock blur true 
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock override-background true 
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock disable-in-overview false 

# Applications Blur
gsettings set org.gnome.shell.extensions.blur-my-shell.applications blur true
gsettings set org.gnome.shell.extensions.blur-my-shell.applications sigma 50
gsettings set org.gnome.shell.extensions.blur-my-shell.applications brightness 1.0 
gsettings set org.gnome.shell.extensions.blur-my-shell.applications opacity 180 
gsettings set org.gnome.shell.extensions.blur-my-shell.applications enable-all true 
gsettings set org.gnome.shell.extensions.blur-my-shell.applications blacklist "['Plank', 'com.desktop.ding', 'Conky']"

# Lockscreen, Screenshot, and Window List Blur
gsettings set org.gnome.shell.extensions.blur-my-shell.lockscreen blur true
gsettings set org.gnome.shell.extensions.blur-my-shell.screenshot blur true 
gsettings set org.gnome.shell.extensions.blur-my-shell.window-list blur true 
gsettings set org.gnome.shell.extensions.blur-my-shell.window-list sigma 30 
gsettings set org.gnome.shell.extensions.blur-my-shell.window-list brightness 0.60 
gsettings set org.gnome.shell.extensions.blur-my-shell.coverflow-alt-tab blur true 

# 5. Compile Dash to Dock schema (to prevent gsettings errors on fresh install)
D2D_SCHEMA_DIR="$HOME/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas"
if [ -d "$D2D_SCHEMA_DIR" ]; then
    glib-compile-schemas "$D2D_SCHEMA_DIR"
    export GSETTINGS_SCHEMA_DIR="$BMS_SCHEMA_DIR:$D2D_SCHEMA_DIR"
fi

# Set Dash to Dock opacity to 0 (completely transparent)
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'FIXED'
gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0.0

# 6. Apply the Orchis Theme
# Set the GTK theme for applications
gsettings set org.gnome.desktop.interface gtk-theme 'Orchis-Dark-Compact'

# Set the GNOME Shell theme (using the User Themes extension)
gsettings set org.gnome.shell.extensions.user-theme name 'Orchis-Dark-Compact'

# 7. Compile Vitals schema (prevents gsettings errors)
VITALS_SCHEMA_DIR="$HOME/.local/share/gnome-shell/extensions/Vitals@CoreCoding.com/schemas"
if [ -d "$VITALS_SCHEMA_DIR" ]; then
    glib-compile-schemas "$VITALS_SCHEMA_DIR"
    export GSETTINGS_SCHEMA_DIR="$GSETTINGS_SCHEMA_DIR:$VITALS_SCHEMA_DIR"
fi

# 8. Apply Vitals Configurations (Intel vPro CPU Focus)
# Ensure the CPU, Temperature, Voltage, and Fan menus are enabled in the dropdown
gsettings set org.gnome.shell.extensions.vitals show-processor true
gsettings set org.gnome.shell.extensions.vitals show-temperature true
gsettings set org.gnome.shell.extensions.vitals show-voltage true
gsettings set org.gnome.shell.extensions.vitals show-fan true

# Pin the specific CPU stats directly to the top bar (Hot Sensors)
gsettings set org.gnome.shell.extensions.vitals hot-sensors "['_processor_usage_', '_processor_frequency_', '_temperature_processor_', '_voltage_processor_']"

# 10. Set the Desktop Wallpaper
RAW_PATH="$PWD/../Style-resources/wallpaper.png"
ABSOLUTE_PATH=$(realpath "$RAW_PATH")
WALLPAPER_URI="file://$ABSOLUTE_PATH"

gsettings set org.gnome.desktop.background picture-uri "$WALLPAPER_URI"
gsettings set org.gnome.desktop.background picture-uri-dark "$WALLPAPER_URI"

echo "Extensions installed and Blur my Shell customized!"
