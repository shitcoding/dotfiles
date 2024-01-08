##### Aliases for default tools replacements ##############
# TODO: Conditional aliases, kinda like this one:
# alias ls='[ -x "$(command -v logo-ls)" ] && logo-ls || ls'

alias l='logo-ls'
alias la='logo-ls -lah'
alias bat='batcat'
alias ping='prettyping'

##### Shorten often used commands ##############
alias rmrf='rm -rf'
alias mkd='mkdir -p'
alias dcmp='docker compose'
alias dcst='docker stop'                                        │
alias dcrm='docker rm'
alias dcps='docker ps --all'

alias cpr='cp -r'

# Wireguard aliases
alias wg='sudo wg'
alias wgu='sudo wg-quick up'
alias wgd='sudo wg-quick down'


##### Various custom commands #############################
# copy absolute path of current working directory to clipboard
# (requires `xclip` to be installed)
alias cpwd='pwd | tr -d "\n" | xclip -selection clipboard'
alias c='pwd | tr -d "\n" | xclip -selection clipboard'

# copy absolute path of target file/directory to clipboard
# (requires `xclip` to be installed)
alias cpls='$HOME/.scripts/copy_filepath.sh'

# Edit zsh_history
alias hist='v ~/.zsh_history'

# Show system notification (useful to notify when task
# that takes a long time is finished)
alias yo="notify-send 'yo!'"

# Output current date (to use in filenames)
alias dnow='date "+%d-%m-%Y"'
# Output current datetime (to use in filenames)
alias dtnow='date "+%d-%m-%Y_%H-%M"'




##### Launching various tools #############################
alias v='lvim'
alias t='tmux'
alias lg='lazygit'


##### Linux shortcuts and various fixes / hacks ##########
# Restart gnome shell (kills open apps)
alias restart-gnome='pkill -HUP gnome-shell && sudo systemctl restart gdm.service'

# Restart pipewire if there are sound glitches
alias restart-sound='systemctl --user restart wireplumber pipewire pipewire-pulse'



##### Pacman aliases #####################################
alias pac='sudo pacman'
alias pacs='sudo pacman -S'
alias pacr='sudo pacman -R'

##### Apt aliases #####################################
alias sap='sudo apt'
alias sai='sudo apt install'
alias sar='sudo apt remove'
alias sau='sudo apt update -y && sudo apt upgrade -y'

##### Nala (cool wrapper for apt) aliases ###########################
alias snu='sudo nala upgrade -y'
alias sni='sudo nala install'


###### Various Python related aliases #######################
# Remove __pycache__ dirs in current directory and subdirectories
alias pcd='find . -type d -name __pycache__ -exec rm -r {} \+'
alias py='python3'
alias pym='python3 -m'

###### Various Fixes and dirty hacks ########################
# Fix scaling for external displays and get rid of cursor flickering glitch
# (xorg only)
alias fxrndr='xrandr --output DP-1 --scale 0.6x0.6 ; xrandr --output HDMI-1 --scale 0.9999x0.9999 ; xrandr --output eDP-1 --scale 0.9999x0.9999'

