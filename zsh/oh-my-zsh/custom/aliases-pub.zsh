##### Aliases for default tools replacements ##############
# TODO: Conditional aliases, kinda like this one:
# alias ls='[ -x "$(command -v logo-ls)" ] && logo-ls || ls'

alias ls='logo-ls'
alias cat='bat'
alias ping='prettyping'

##### Shorten often used commands ##############
alias rmrf='rm -rf'
alias mkd='mkdir -p'
alias cpr='cp -r'

# Docker
alias dcmp='docker-compose'
alias dcst='docker stop'
alias dcrm='docker rm'
alias dcps='docker ps --all'


##### Various custom commands #############################
# copy absolute path of current working directory to clipboard
# (requires `xclip` to be installed)
alias cpwd='pwd | tr -d "\n" | xclip -selection clipboard'
# copy absolute path of target file/directory to clipboard
# (requires `xclip` to be installed)
alias cpls='$HOME/.scripts/copy_filepath.sh'
# Edit zsh_history
alias hist='v ~/.zsh_history'
# Show system notification (useful to notify when task
# that takes a long time is finished)
alias yo="notify-send 'yo!'"

##### Launching various tools #############################
alias v='lvim'
alias lg='lazygit'


##### Pacman aliases #####################################
alias pac='sudo pacman'
alias pacs='sudo pacman -S'
alias pacr='sudo pacman -R'

##### Apt aliases #####################################
alias sap='sudo apt'
alias sai='sudo apt install'
alias sar='sudo apt remove'
alias sau='sudo apt update -y && sudo apt upgrade -y'


###### Various Python related aliases #######################
# Remove __pycache__ dirs in current directory and subdirectories
alias pcd='find . -type d -name __pycache__ -exec rm -r {} \+'
alias py='python3'
alias pym='python3 -m'

###### Various Fixes and dirty hacks ########################
# Fix scaling for external displays and get rid of cursor flickering glitch
# (xorg only)
alias fxrndr='xrandr --output DP-1 --scale 0.6x0.6 ; xrandr --output HDMI-1 --scale 0.9999x0.9999 ; xrandr --output eDP-1 --scale 0.9999x0.9999'


###### AWS cli aliases #######################################
# Set current IP for inbound ssh connections for target security
# group and remove all other IPs
alias aws_ssh_reset='$HOME/.scripts/aws_set_current_ip_ssh_for_group.sh'
