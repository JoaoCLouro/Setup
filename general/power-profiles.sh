#!/bin/bash

# The 11th-gen vPro uses the Intel P-State driver. We can automate the CPU profile rules:
echo "Configuring TLP CPU profiles..."

# Set AC to maximum performance profile
sudo sed -i 's/^#CPU_ENERGY_PERF_POLICY_ON_AC=.*/CPU_ENERGY_PERF_POLICY_ON_AC=performance/' /etc/tlp.conf
sudo sed -i 's/^#CPU_SCALING_GOVERNOR_ON_AC=.*/CPU_SCALING_GOVERNOR_ON_AC=performance/' /etc/tlp.conf

# Set Battery to balanced/power-saving profile
sudo sed -i 's/^#CPU_ENERGY_PERF_POLICY_ON_BAT=.*/CPU_ENERGY_PERF_POLICY_ON_BAT=balance_power/' /etc/tlp.conf
sudo sed -i 's/^#CPU_SCALING_GOVERNOR_ON_BAT=.*/CPU_SCALING_GOVERNOR_ON_BAT=powersave/' /etc/tlp.conf

# Restart TLP to apply the new hardware profiles immediately
sudo systemctl restart tlp.service
