#!/bin/sh

set -e

echo "====================="
echo "0. Prepare for launch dotfile."
# in docker
if [ `whoami` == 'root' ];then
    apt-get update && apt-get install -y sudo
fi

sudo apt update && sudo apt-get install -y python3-distutils curl wget
# get pip3
curl -O https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py

# install zsh
sudo apt-get update && sudo apt-get install -f -y zsh autojump git
chsh -s /bin/zsh

echo "====================="
echo "1. Backup your config files. e.g. ~/.zshrc -> ~/.zshrc.backup"
# Require Vim with Lua
if [ -f "$HOME/.zshrc" ];then
  echo "$file found."
  mv ~/.zshrc ~/.zshrc.backup
else
  echo "$file not found."
fi

echo "====================="
echo "2. Install zsh plugin"

# install oh-my-zsh
rm -rf ~/.oh-my-zsh
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

sudo cp zshrc ~/.zshrc
sudo cp my-shortkey ~/.oh-my-zsh/

echo "====================="
echo "3. Install Lazy vim"

sudo apt-get install -f -y software-properties-common build-essential

# install neo vim
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update && apt-get install -f -y neovim lua5.3

# install LazyVim
rm -rf ~/.config/nvim ~/.local/share/nvim 
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git


echo "====================="
echo "Success!"

