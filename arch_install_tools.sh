#!/usr/bin/env bash

# Update packages
sudo pacman -Syu --noconfirm

# Install useful tools: zsh, oh-my-zsh, p10k prompt, tmux, LunarVim, etc.

# Install zsh, oh-my-zsh, plugins, set up config ###########
# Download dotfiles
git clone https://github.com/shitcoding/dotfiles ~/.dotfiles

#Install zsh, oh-my-zsh and plugins ###########################
# Set up zsh and other tools
sudo pacman -S curl git zsh wget fzf alacritty rustup --noconfirm
sudo chsh -s $(which zsh) $USER
# Set up oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
# Install oh-my-zsh plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/joshskidmore/zsh-fzf-history-search ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search

# Fix permissions issues for downloaded plugins
chown -R $(whoami):$(whoami) $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
chown -R $(whoami):$(whoami) $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
chown -R $(whoami):$(whoami) $HOME/.oh-my-zsh/custom/plugins/zsh-fzf-history-search

# Install nerd fonts
sudo pacman -S ttf-inconsolata-nerd ttf-meslo-nerd ttf-hack-nerd ttf-firacode-nerd ttf-iosevka-nerd --noconfirm

# Install powerlevel10k prompt
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Copy zsh dotfiles, aliases, env vars
cp ~/.dotfiles/zsh/.zshrc ~/.zshrc
cp ~/.dotfiles/powerlevel10k/.p10k.zsh ~/.p10k.zsh
cp ~/.dotfiles/zsh/oh-my-zsh/custom/* $ZSH_CUSTOM

# Copy alacritty config
mkdir -p ~/.config/alacritty
cp ~/.dotfiles/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml


############ Install tmux and plugins ###########################
sudo pacman -S tmux xclip --noconfirm
# Install tpm plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Copy tmux config from downloaded dotfiles
cp ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf


########## Install Lunarvim, set up config and plugins ###########
# Install latest version of Neovim
sudo pacman -S neovim --noconfirm

# Install LunarVim dependencies
# install rust
sudo curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
sudo pacman -S make unzip python3-pip python3 python3-venv -y
#Install nvm, nodejs, npm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
source ~/.zshrc > /dev/null
nvm install node
nvm install-latest-npm

# Install LunarVim  + its nodejs/python/rust dependencies
bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) << EOF
y
y
y
EOF
# Add path to lvim executable to system $PATH
echo "export PATH=$HOME/.local/bin:$PATH" >> $ZSH_CUSTOM/env.zsh

# Set lvim config from dotfiles
cp $HOME/.dotfiles/lvim/config.lua $HOME/.config/lvim/config.lua
mkdir -p $HOME/.config/lvim/after/ftplugin/
cp $HOME/.dotfiles/lvim/htmldjango.vim $HOME/.config/lvim/after/ftplugin/htmldjango.vim


###### Various tools ############################
# paru
mkdir -p ~/Utils
cd ~/Utils
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

# logo-ls
paru -S logo-ls --noconfirm --skipreview

# Gnome extensions
sudo pacman -S gnome-shell-extensions gnome-browser-connector --noconfirm
# Load Gnome config from dotfiles
dconf load / < ~/.dotfiles/gnome/gnome-settings.ini

# Install Firefox and Tridactyl firefox extension and copy config from dotfiles
sudo pacman -S firefox firefox-tridactyl --noconfirm
paru -S firefox-tridactyl-native --noconfirm --skipreview
mkdir -p ~/.config/tridactyl/
cp ~/.dotfiles/firefox/tridactylrc ~/.config/tridactyl/tridactylrc
