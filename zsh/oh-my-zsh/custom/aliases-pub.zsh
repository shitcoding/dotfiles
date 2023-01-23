##### Aliases for default tools replacements ##############
# TODO: Conditional aliases, kinda like this one:
# alias ls='[ -x "$(command -v logo-ls)" ] && logo-ls || ls'

alias ls='logo-ls'
alias cat='bat'
alias ping='prettyping'

##### Shorten often used commands ##############
alias rmrf='rm -rf'
alias mkd='mkdir -p'
alias dcmp='docker-compose'

##### Various custom commands #############################
# copy absolute path of current working directory to clipboard
# (requires `xclip` to be installed)
alias cpwd='pwd | tr -d "\n" | xclip -selection clipboard'
# copy absolute path of target file/directory to clipboard
# (requires `xclip` to be installed)
alias cpls='$HOME/.scripts/copy_filepath.sh'
# Edit zsh_history
alias hist='v ~/.zsh_history'

##### Launching various tools #############################
alias v='lvim'
alias lg='lazygit'


##### Pacman aliases #####################################
alias pac='sudo pacman'
alias pacs='sudo pacman -S'
alias pacr='sudo pacman -R'


###### Various Python related aliases #######################
alias pcd='find . -type d -name __pycache__ -exec rm -r {} \+'
alias py='python3'
alias pym='python3 -m'

###### Various Fixes and dirty hacks ########################
# Fix scaling for external displays and get rid of cursor flickering glitch
# (xorg only)
alias fixrandr='xrandr --output DP-1 --scale 0.6x0.6 ; xrandr --output HDMI-1 --scale 0.9999x0.9999 ; xrandr --output eDP-1 --scale 0.9999x0.9999'

