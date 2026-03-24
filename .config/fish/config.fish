if status is-interactive
    starship init fish | source
    zoxide init fish | source
    nvm use 24

    alias g="git"
    alias ga="git add ."
    alias d="docker"
    alias x="exit"

    alias t="tmux"
    alias tn="tmux new -s "
    alias muxi="tmuxifier"
    alias muxi-load="tmuxifier load-session"
    alias muxi-new="tmuxifier new-layout"

    alias ii="npm install"
    alias dev="npm run dev"

    alias v="nvim"
    alias nv="nvim"

    alias rgf="rg --files | rg"
    alias fd="fdfind"
    alias qw="ls -alt | head -n"

    alias dps="~/docker-ps-visual.sh"
    alias dpr="~/docker-ps-visual.sh -r"
    alias dpa="~/docker-ps-visual.sh -a"
    alias dpar="~/docker-ps-visual.sh -a -r"

    function tn
        tmux new -s $argv
    end
end

set -Ux fish_user_paths \
    /opt/nvim/bin \
    $HOME/.bun/bin \
    $HOME/.dotnet \
    $HOME/.dotnet/tools \
    $HOME/.tmuxifier/bin \
    $HOME/.config/herd-lite/bin \
    $fish_user_paths

# DOTNET
set -gx DOTNET_ROOT $HOME/.dotnet

# BUN
set -gx BUN_INSTALL $HOME/.bun
