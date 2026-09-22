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

echo "==> Updating package databases and upgrading system..."
# FAILSAFE: If pacman fails, fetch a fresh global HTTPS mirrorlist
if ! sudo pacman -Syu --noconfirm; then
    echo "============================================================"
    echo "WARNING: System update failed. This is often due to outdated mirrors."
    echo "Activating failsafe: Fetching a fresh global HTTPS mirrorlist..."
    echo "============================================================"
    
    sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
    sudo curl -s "https://archlinux.org/mirrorlist/?country=all&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' | sudo tee /etc/pacman.d/mirrorlist > /dev/null
    
    echo "==> Retrying system update..."
    if ! sudo pacman -Syyu --noconfirm; then
        echo "ERROR: Failsafe update also failed. Please check your internet connection."
        exit 1
    fi
fi

echo "==> Installing system packages..."
sudo pacman -S --noconfirm --needed \
    git \
    base-devel \
    gdb \
    neovim \
    python \
    python-pip \
    curl \
    wget \
    github-cli \
    ripgrep \
    fd \
    clang \
    pyright \
    firefox \
    gmp \
    libffi \
    ncurses \
    btop

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
