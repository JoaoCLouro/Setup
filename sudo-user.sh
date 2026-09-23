#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "[-] Please run this script as root (sudo ./grant_sudo.sh)." >&2
  exit 1
fi

# Prompt for the existing username
read -p "Enter the existing username to grant superuser privileges to: " USERNAME

# Verify that the user actually exists on the system
if ! id "$USERNAME" &>/dev/null; then
    echo "[-] Error: User '$USERNAME' does not exist. Aborting." >&2
    exit 1
fi

# Determine the correct administrative group (Debian uses 'sudo', Arch usually uses 'wheel')
if grep -qEi "debian" /etc/os-release; then
    ADMIN_GROUP="sudo"
elif grep -qEi "arch" /etc/os-release; then
    ADMIN_GROUP="wheel"
else
    # Fallback default
    ADMIN_GROUP="sudo"
fi

# Add user to the administrative group
usermod -aG "$ADMIN_GROUP" "$USERNAME"
echo "[+] User '$USERNAME' has been successfully added to the '$ADMIN_GROUP' group."

echo "$USERNAME is now a sudo user!"
