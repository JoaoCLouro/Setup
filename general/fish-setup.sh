#!/bin/bash

# Updates all packages
if command -v pacman &> /dev/null; then
    sudo pacman -Syyu
elif command -v apt &> /dev/null; then
    sudo apt update && sudo apt upgrade

# Fetches oh-my-posh
curl -s https://ohmyposh.dev/install.sh | bash -s

# Give full permissions to oh my posh
sudo chmod 777 /home/$USER/.local/bin/oh-my-posh
# Should prompt for the password

# Appeds the ambiant var setting command to the end of the bashrc
echo "export PATH=$PATH:/home/$USER/.local/bin/" >> /home/$USER/.bashrc
# Refreches the bash command
source ~/.bashrc

unzip $PWD/Fonts/Go-Mono.zip -d ~/.local/share/fonts

# Updates the font cache
sudo fc-cache -f -v
# Should prompt for password

# Sets the monospace font and size
gsettings set org.gnome.desktop.interface monospace-fonts-name 'GoMono Nerd Font 11'

# Set the fish file configs for the terminal styling
sed -i "1i\\fastfetch\noh-my-posh init fish -c ~/.cache/oh-my-posh/themes/atomic.omp.json | source"

# restart the fish terminal
exit
fish

# Adds the bin folder to the fish paths and changes the user shell
fish_add_path ~/.local/bin/
chsh -s $(which fish)
