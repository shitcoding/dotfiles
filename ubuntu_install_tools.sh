#!/usr/bin/env bash

##################### Install tools for Ubuntu #####################

# Update packages
sudo apt update && sudo apt upgrade -y

# Download dotfiles
git clone https://github.com/shitcoding/dotfiles ~/.dotfiles

# Install useful tools: alacritty, zsh, oh-my-zsh, p10k prompt, tmux, LunarVim, etc.
#
# Install alacritty and copy config from dotfiles
sudo apt install alacritty -y
mkdir -p ~/.config/alacritty
cp ~/.dotfiles/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml

# Download and install Nerd Fonts
mkdir -p ~/Utils/
cd ~/Utils
git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts.git
cd nerd-fonts
./install.sh MesloLG
./install.sh Hack
./install.sh FiraCode


# Install zsh, oh-my-zsh, plugins, set up config ###########
# Set up zsh and other tools
sudo apt install curl git zsh wget fzf -y
sudo chsh -s $(which zsh) $USER
# Set up oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
# Install oh-my-zsh plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/joshskidmore/zsh-fzf-history-search ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search

# Fix permissions issues for downloaded plugins (in case there are issues)
chown -R $(whoami):$(whoami) $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
chown -R $(whoami):$(whoami) $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
chown -R $(whoami):$(whoami) $HOME/.oh-my-zsh/custom/plugins/zsh-fzf-history-search

# Install powerlevel10k prompt
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Copy zsh dotfiles, aliases, env vars
cp ~/.dotfiles/zsh/.zshrc ~/.zshrc
cp ~/.dotfiles/powerlevel10k/.p10k.zsh ~/.p10k.zsh
cp ~/.dotfiles/zsh/oh-my-zsh/custom/* $ZSH_CUSTOM


############ Install tmux and plugins ###########################
sudo apt install tmux -y
# Install tpm plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Copy tmux config from downloaded dotfiles
cp ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf


########## Install Lunarvim, set up config and plugins ###########
# Install latest version of Neovim
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install neovim -y

# Install LunarVim dependencies
# install rust
sudo curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
sudo apt install make unzip python3-pip python3 python3-venv -y
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
#echo "export PATH=/home/ubuntu/.local/bin:$PATH" >> $ZSH_CUSTOM/env.zsh
echo "export PATH=$HOME/.local/bin:$PATH" >> $ZSH_CUSTOM/env.zsh

# Set lvim config from dotfiles
cp $HOME/.dotfiles/lvim/config.lua $HOME/.config/lvim/config.lua
mkdir -p $HOME/.config/lvim/after/ftplugin/
cp $HOME/.dotfiles/lvim/htmldjango.vim $HOME/.config/lvim/after/ftplugin/htmldjango.vim


###### Various tools ############################
# logo-ls
wget -P /tmp https://github.com/Yash-Handa/logo-ls/releases/latest/download/logo-ls_amd64.deb
sudo dpkg -i /tmp/logo-ls_amd64.deb



# Install Docker
sudo apt install \
	ca-certificates \
	curl \
	gnupg \
	lsb-release -y
# Add Docker’s official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
# Set up the repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# Update the apt package index
sudo apt update
# Install Docker Engine, containerd, and Docker Compose
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose -y
# Create the `docker` group
sudo groupadd -f docker
# Add your user to the docker group
sudo usermod -aG docker $USER
# Activate the changes to groups
newgrp docker
