#!/bin/bash

# Usage
# ./runner.sh [flags space separated]

# ===============
# Flag interface
# ===============

# OS detection:
# -d :debian
# -a :arch
#

# Installation type:
#
# [default/ no flag] full install
#
# -m    (minimal installation: see [minimal installation](#minimal installation packages))
# 
# -dry (no package installed)
#
# Desktop Env:
#
# [default/no flag] tailling window manager (to choose default)
# -g (gnome)
#
# To complete later


parse_args() {
    # Buffer components:
    # os type (0 - arch; 1 - debian)
    # dry run (0 - no, 1 - yes)
    # installation type (0 - full; 1 - base)
    # DE type (0 - window manager; 1 - gnome)
    flags=(0 0 0 0)
    for arg in $@;
    do
        case "$arg" in
            -d)
                flags[0]=1
                ;;
            -dry)
                flags[1]=1
                ;;
            -m)
                flags[2]=1
                ;;
            -g)
                flags[3]=1
                ;;
        esac
    done
        
}

chmod +x "arch-config/setup-arch.sh"
chmod +x "debian-config/setup-debian.sh"
chmod +x "general/*.sh"


if [[ $? -gt 1]]; then
    parse_args $@
else 
    flags=(0 0 0 0)
fi



if [[ "$flags[1]" -eq "1"]] then
    installation_mode="-n"
elif [[ "$flags[2]" -eq "1"]] then
    installation_mode="-m"
else
    installation_mode="-f"
fi

if [[ "$flags[0]" -eq 1 ]] then
    ./debian-config/setup-debian.sh "$installation_mode"
else
   ./arch-config/setup-arch.sh "$installation_mode" 
fi

if [[ "$flags[3]" -eq 1]] then
    chmod +x "DE/GNOME-setup.sh"
    ./DE/GNOME-setup.sh
else 
    chmod +x "DE/TWM-setup.sh"
    ./DE/TWM-setup.sh
fi

chmod +x "general/*.sh"
./general/*.sh


