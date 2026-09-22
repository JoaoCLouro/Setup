#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_CONFIG_DIR="$HOME/.config/nvim"

echo "==> Checking Git configuration..."
if [ -z "$(git config --global user.name)" ] || [ -z "$(git config --global user.email)" ]; then
    echo "Git global identity is not set. Please configure it:"
    read -p "Enter your Git Name (e.g., João Louro): " git_name
    read -p "Enter your Git Email: " git_email
    
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
    echo "Git global identity configured successfully."
else
    echo "Git identity already configured."
fi

echo "==> Updating package lists..."
# FAILSAFE: Try normal update. If it fails, apply network fixes.
if ! sudo apt update; then
    echo "============================================================"
    echo "WARNING: Standard 'apt update' failed (likely network/mirror issues)."
    echo "Activating failsafe: Switching to global Debian mirrors and forcing IPv4..."
    echo "============================================================"
    
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
    
    sudo sed -i 's/ftp.rnl.tecnico.ulisboa.pt/deb.debian.org/g' /etc/apt/sources.list
    sudo sed -i 's/ftp.rnl.tecnico.ulisboa.pt/deb.debian.org/g' /etc/apt/sources.list.d/*.list 2>/dev/null || true
    
    echo 'Acquire::ForceIPv4 "true";' | sudo tee /etc/apt/apt.conf.d/99force-ipv4 > /dev/null
    
    echo "==> Retrying apt update with failsafe settings..."
    if ! sudo apt update; then
        echo "ERROR: Failsafe update also failed. Please check your internet connection."
        exit 1
    fi
fi

echo "==> Upgrading existing packages..."
sudo apt upgrade -y

echo "==> Installing system packages (Git, C essentials, Python, GitHub CLI, Node.js, Firefox)..."
sudo apt install -y \
    git \
    build-essential \
    gdb \
    neovim \
    python3 \
    python3-pip \
    python3-venv \
    curl \
    wget \
    gh \
    ripgrep \
    fd-find \
    clangd \
    nodejs \
    npm \
    firefox-esr \
    libgmp-dev \
    libffi-dev \
    libncurses-dev

echo "==> Installing Pyright Language Server via npm..."
sudo npm install -g pyright

echo "==> Installing Rust (rustup)..."
if ! command -v rustc &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
else
    echo "Rust is already installed."
fi

if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

echo "==> Installing Rust development tools (bacon, cargo-nextest)..."
if command -v cargo &> /dev/null; then
    cargo install bacon cargo-nextest --locked
else
    echo "Warning: cargo not found. Skipping cargo tools installation."
fi

echo "==> Installing Haskell Toolchain (ghcup, ghc, cabal, stack, hls)..."
export BOOTSTRAP_HASKELL_NONINTERACTIVE=1
export BOOTSTRAP_HASKELL_INSTALL_STACK=1
export BOOTSTRAP_HASKELL_INSTALL_HLS=1
export BOOTSTRAP_HASKELL_ADJUST_BASHRC=1

if ! command -v ghcup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
else
    echo "GHCup is already installed."
fi

if [ -f "$HOME/.ghcup/env" ]; then
    source "$HOME/.ghcup/env"
fi

echo "==> Setting up Neovim configuration..."
mkdir -p "$NVIM_CONFIG_DIR"

if [ -f "$SCRIPT_DIR/nvim-config.lua" ]; then
    echo "Copying contents of nvim-config.lua into $NVIM_CONFIG_DIR/init.lua..."
    cat "$SCRIPT_DIR/nvim-config.lua" > "$NVIM_CONFIG_DIR/init.lua"
else
    echo "Warning: nvim-config.lua not found in $SCRIPT_DIR. Please ensure it exists alongside this script."
fi

echo "==> Setup complete!"
