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
# Dry run:
# -dry (no package installed)
#
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




