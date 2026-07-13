if status is-interactive
    starship init fish | source

    if type -q zoxide
        zoxide init fish --cmd cd | source
    end

    alias g="git"
    alias ga="git add ."
    alias d="docker"
    alias x="exit"

    alias ii="npm install"
    alias dev="npm run dev"

    alias v="nvim"
    alias nv="nvim"

    alias rgf="rg --files | rg"
    alias fd="fdfind"

    if type -q eza
        alias ls="eza --group-directories-first --icons --git"
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
                --icons=always \
                --color=always \
                --git \
                | head -n $n
        end
    else
        alias la="ls -lah --color=auto"
        alias ll="ls -lh --color=auto"

        function qw
            set -l n 10

            if test (count $argv) -ge 1
                set n $argv[1]
            end

            ls -laht --color=always | head -n $n
        end
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
    $HOME/.config/herd-lite/bin \
    $fish_user_paths

# DOTNET
set -gx DOTNET_ROOT $HOME/.dotnet

# BUN
set -gx BUN_INSTALL $HOME/.bun

# PYENV_ROOT
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin
pyenv init - | source
