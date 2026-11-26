if status is-interactive
    alias g="git"
    alias ga="git add ."
    function gac
        git add .; and git commit -m "$argv"
    end
    alias d="docker"
    alias x="exit"

    alias ii="npm install"
    alias dev="npm run dev"

    alias v="nvim"
    alias nv="nvim"

    alias rgf="rg --files | rg"
    alias rgh="rg --files --hidden | rg"

    alias tarnow="tar -acf "
    alias untar="tar -xvf "
    alias ..="cd .."
    alias ...="cd ../.."
    alias ....="cd ../../.."

    alias ff "fzf --preview 'bat --style=numbers --color=always {}'"
    function eff
        set -l file (ff)
        and test -n "$file"
        and nvim $file $argv
    end

    function open
        for f in $argv
            xdg-open $f >/dev/null 2>&1 &
            disown
        end
    end

    function fip
        if test (count $argv) -lt 2
            echo "Uso: fip <host> <puerto1> [puerto2] ..."
            return 1
        end
        set -l host $argv[1]
        for port in $argv[2..]
            ssh -f -N -L $port:localhost:$port $host
            and echo "Túnel: localhost:$port -> $host:$port"
        end
    end

    function dip
        if test (count $argv) -eq 0
            echo "Uso: dip <puerto1> [puerto2] ..."
            return 1
        end
        for port in $argv
            pkill -f "ssh.*-L $port:localhost:$port"
            and echo "Túnel cerrado: $port"
            or echo "No hay túnel en el puerto $port"
        end
    end

    function lip
        pgrep -af "ssh.*-L [0-9]+:localhost:[0-9]+"
        or echo "No hay túneles activos"
    end
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

    alias t="tmux"
    function tn
        tmux new -s $argv
    end
    function tw
        tmux new-window -n $argv
    end

    function claude
        set -l tmp (mktemp)
        if jq --arg d (pwd) '.projects[$d].hasTrustDialogAccepted = true' ~/.claude.json >$tmp
            cat $tmp >~/.claude.json
        end
        rm -f $tmp
        command claude $argv
    end
    alias cl="claude"

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
