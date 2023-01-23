export PATH=$PATH:$HOME/.local/bin:$HOME/.npm-global/bin:$HOME/go/bin
export XDG_CONFIG_HOME=$HOME/.config
export EDITOR=$HOME/.local/bin/lvim

# Set up lunarvim in order to make tmux-resurrect plugin restore lvim sessions
export LUNARVIM_RUNTIME_DIR="${LUNARVIM_RUNTIME_DIR:-"$HOME/.local/share/lunarvim"}"
export LUNARVIM_CONFIG_DIR="${LUNARVIM_CONFIG_DIR:-"$HOME/.config/lvim"}"
export LUNARVIM_CACHE_DIR="${LUNARVIM_CACHE_DIR:-"$HOME/.cache/lvim"}"
