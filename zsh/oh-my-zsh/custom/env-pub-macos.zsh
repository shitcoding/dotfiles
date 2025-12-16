export PATH=$PATH:$HOME/.local/bin:$HOME/.npm-global/bin
# hidden Go directory
export GOPATH=$HOME/.go
export PATH=$PATH:$GOPATH/bin

export XDG_CONFIG_HOME=$HOME/.config
export EDITOR=nvim
export EZA_CONFIG_DIR=$HOME/.config/eza/

# Set up lunarvim in order to make tmux-resurrect plugin restore lvim sessions
export LUNARVIM_RUNTIME_DIR="${LUNARVIM_RUNTIME_DIR:-"$HOME/.local/share/lunarvim"}"
export LUNARVIM_CONFIG_DIR="${LUNARVIM_CONFIG_DIR:-"$HOME/.config/lvim"}"
export LUNARVIM_CACHE_DIR="${LUNARVIM_CACHE_DIR:-"$HOME/.cache/lvim"}"

# Custom functions to prettify / colorize curl output
# json (requires pygments to be installed via `pip install pygments`)
function jcurl() {
    curl "$@" -s | json_pp | pygmentize -l json
}

export jcurl
