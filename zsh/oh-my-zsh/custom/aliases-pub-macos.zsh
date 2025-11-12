##### Aliases for default tools replacements ##############
# TODO: Conditional aliases, kinda like this one:
# alias ls='[ -x "$(command -v logo-ls)" ] && logo-ls || ls'

alias l='eza --icons'
alias la='eza -lah --icons'
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

# Tmux aliases#################################
# Launch tmux, restore last session with tmux-resurrect plugin
# and attach to `main` session
alias tmr='tmux new-session -d -s kekek && echo "Restoring saved tmux sessions..." && tmux run-shell $HOME/.tmux/plugins/tmux-resurrect/scripts/restore.sh && tmux kill-session -t kekek && tmux attach -t main'


##### Various custom commands #############################
# copy absolute path of current working directory to clipboard
# MacOS
alias cpwd='pwd | tr -d "\n" | pbcopy'
alias c='pwd | tr -d "\n" | pbcopy'

# copy absolute path of target file/directory to clipboard
############### MacOS ###############
alias cpls='$HOME/.scripts/copy_filepath_macos.sh'

# Edit zsh_history
alias hist='v ~/.zsh_history'

# Show system notification (useful to notify when task
# that takes a long time is finished)
alias yo="notify-send 'yo!'"

# Output current date (to use in filenames)
alias dnow='date "+%d-%m-%Y"'
alias rdnow='date "+%Y-%m-%d"' #reversed for better sorting by filename
# Output current datetime (to use in filenames)
alias dtnow='date "+%d-%m-%Y_%H-%M"'
alias rdtnow='date "+%Y-%m-%d_%H-%M"' #reversed for better sorting by filename

# Encode a string in qr code and output to terminal
alias qrstring='qrencode -t ansiutf8'


##### Launching various tools #############################
alias v='lvim'
alias t='tmux'
alias lg='lazygit'
alias ldc='lazydocker'


##### AI tool aliases #############################
alias aie='aichat -e'


##### Soundcloud and music #############################
alias scld='scdl --path ~/Downloads/_music --onlymp3 -l ' # Download one track


###### Various Python related aliases #######################
# Remove __pycache__ dirs in current directory and subdirectories
alias pcd='find . -type d -name __pycache__ -exec rm -r {} \+'
alias py='python3'
alias pym='python3 -m'
