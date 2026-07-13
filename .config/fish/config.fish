if status is-interactive
    starship init fish | source
    zoxide init fish | source

    alias g="git"
    alias ga="git add ."
    alias d="docker"
    alias x="exit"

    alias muxi="tmuxifier"
    alias muxi-load="tmuxifier load-session"
    alias muxi-new="tmuxifier new-layout"

    alias ii="npm install"
    alias dev="npm run dev"

    alias v="nvim"
    alias nv="nvim"

    alias rgf="rg --files | rg"
    alias fd="fdfind"

    alias lf="eza --group-directories-first --icons --git"
    alias la="eza -lah --group-directories-first --icons --git"
    alias ll="eza -lh --group-directories-first --icons --git"

    function qw
        set -l n 10

        if test (count $argv) -ge 1
            set n $argv[1]
        end

        eza \
            -lah \
            --sort=modified \
            --reverse \
            --group-directories-first \
            --icons \
            --git \
            | head -n $n
    end

    alias dps="~/docker-ps-visual.sh"
    alias dpr="~/docker-ps-visual.sh -r"
    alias dpa="~/docker-ps-visual.sh -a"
    alias dpar="~/docker-ps-visual.sh -a -r"

    # tmux customization
    alias t="tmux"
    alias tn="tmux new -s "
    function tn
        tmux new -s $argv
    end
    function tw
        tmux new-window -n $argv
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

# opencode
fish_add_path /home/attemptx/.opencode/bin
