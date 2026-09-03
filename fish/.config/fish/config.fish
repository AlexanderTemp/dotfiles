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
    alias rgh="rg --files --hidden | rg"

    # Common use get it from sway config utils
    alias tarnow="tar -acf "
    alias untar="tar -xvf "
    alias ..="cd .."
    alias ...="cd ../.."
    alias psmem10='ps auxf | sort -nr -k 4 | head -10'

    alias hw='hwinfo --short'
    alias jctl="journalctl -p 3 -xb"
    alias update='sudo cachyos-rate-mirrors && sudo pacman -Syu'

    if type -q eza
        alias ls="eza --group-directories-first --icons --git"
        alias lf="eza --group-directories-first --icons --git"
        alias la="eza -lah --group-directories-first --icons --git"
        alias ll="eza -lh --group-directories-first --icons --git"
        alias lt='eza -aT --color=always --group-directories-first --icons=always'

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
    function tn
        tmux new -s $argv
    end
    function tw
        tmux new-window -n $argv
    end

    function mdpreview
        if test (count $argv) -eq 0
            echo "Uso: mdpreview archivo.md"
            return 1
        end

        set input (realpath $argv[1])

        if not test -f "$input"
            echo "Error: no existe el archivo '$input'"
            return 1
        end

        set tmpdir (mktemp -d /tmp/mdpreview.XXXXXX)
        set output "$tmpdir/preview.html"

        function __mdpreview_cleanup --on-process-exit %self
            rm -rf "$tmpdir"
        end

        pandoc "$input" \
            --standalone \
            --metadata title="Markdown Preview" \
            --highlight-style=pygments \
            -o "$output"

        if test $status -ne 0
            echo "Error: Pandoc no pudo convertir el archivo."
            rm -rf "$tmpdir"
            return 1
        end

        echo "Preview: $output"

        xdg-open "$output" >/dev/null 2>&1 &
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

# GOPATH
set -gx GOPATH $HOME/go
fish_add_path $GOPATH/bin

# PYENV_ROOT
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin

# SDKMAN (java) -- fish no soporta sourcear sdkman-init.sh (es bash),
# asi que se apunta directo al symlink "current" que administra sdkman con
# "sdk default"/"sdk use". Se prepende con fish_add_path para que gane sobre
# cualquier java del sistema.
set -gx SDKMAN_DIR $HOME/.sdkman
set -gx JAVA_HOME $SDKMAN_DIR/candidates/java/current
fish_add_path $JAVA_HOME/bin

fish_add_path $HOME/.local/bin

# SDKMAN (el plugin sdkman-for-fish no actualiza el PATH en `sdk use`/`sdk default`,
# así que apuntamos directo al symlink `current` que sdkman sí mantiene al día)
set -gx SDKMAN_DIR $HOME/.sdkman
fish_add_path -p $SDKMAN_DIR/candidates/java/current/bin

if type -q pyenv
    pyenv init - | source
end

source ~/.adas-cli/.adas-cli-completion-fish
