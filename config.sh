#!/bin/sh

set -e

echo "====================="
echo "0. Prepare for launch dotfile."

# Determine the current user
if [ "$(whoami)" = "root" ]; then
    SUDO=""
else
    SUDO="sudo"
fi

# Update and install necessary packages
$SUDO apt-get update && $SUDO apt-get install -y python3-distutils curl wget

# Get pip3
curl -O https://bootstrap.pypa.io/get-pip.py && $SUDO python3 get-pip.py

# Install zsh
$SUDO apt-get update && $SUDO apt-get install -y zsh autojump git
$SUDO chsh -s /bin/zsh

echo "====================="
echo "1. Backup your config files. e.g. ~/.zshrc -> ~/.zshrc.backup"

# Backup existing .zshrc file
if [ -f "$HOME/.zshrc" ]; then
    echo "$HOME/.zshrc found."
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
else
    echo "$HOME/.zshrc not found."
fi

echo "====================="
echo "2. Install zsh plugins"

# Install oh-my-zsh
rm -rf "$HOME/.oh-my-zsh"
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

$SUDO cp zshrc "$HOME/.zshrc"
$SUDO cp my-shortkey "$HOME/.oh-my-zsh/"

echo "====================="
echo "3. Install LazyVim"

$SUDO apt-get install -y software-properties-common build-essential

# Install neovim
$SUDO add-apt-repository ppa:neovim-ppa/unstable
$SUDO apt-get update && $SUDO apt-get install -y neovim lua5.3

# Install LazyVim
rm -rf "$HOME/.config/nvim" "$HOME/.local/share/nvim"
git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
rm -rf "$HOME/.config/nvim/.git"

echo "====================="
echo "Success!"
