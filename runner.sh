#!/bin/bash

# Usage
# ./runner.sh -- [flags space separated]

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

chmod +x "arch-config/setup-arch.sh"
chmod +x "debian-config/setup-arch.sh"
chmod +x "general/*.sh"

if [[ $? -gt 1]]; then
    local $args=$(parse_args $@) # See how to skip first arg
else 
    local $args=""
fi




