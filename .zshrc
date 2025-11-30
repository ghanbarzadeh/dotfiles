# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"


# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    # zsh-autosuggestions
    # zsh-syntax-highlighting
)

# Install custom plugins
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
#   git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
# fi

# if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
#   git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
# fi

source $ZSH/oh-my-zsh.sh
# User configuration

alias ll='ls -AlF'

# For correct tmux folder colors
eval "$(dircolors -b ~/.dircolors)"

# NEOVIM
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

export CC=clang
export CXX=clang++
