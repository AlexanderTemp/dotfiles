#!/usr/bin/env bash
# Bootstrap de paquetes para Arch/CachyOS -- no instala nvim (manual, ver README.md).

set -euo pipefail

# Fuerza mensajes de pacman en inglés (Y/n) sin tocar el locale/teclado del sistema.
export LC_ALL=C.UTF-8

log() { printf '\n\033[1;34m==> %s\033[0m\n' "$1"; }

# -e mudo es imposible de debuggear: marca línea y comando exacto al fallar.
on_error() {
    local exit_code=$?
    printf '\n\033[1;31m✗ FALLÓ (línea %s): %s\033[0m\n' "$1" "$2" >&2
    exit "$exit_code"
}
trap 'on_error "$LINENO" "$BASH_COMMAND"' ERR

pacman_install() {
    # pacman -T respeta Provides (evita chocar con reemplazos de CachyOS, ej. zlib-ng-compat vs zlib)
    local missing
    missing=$(pacman -T "$@" 2>/dev/null || true)
    if [ -z "$missing" ]; then
        log "ya satisfechos: $*"
        return 0
    fi
    log "pacman: $missing"
    # shellcheck disable=SC2086
    sudo pacman -S --needed $missing
}

log "Actualizando índices de paquetes y el sistema"
sudo pacman -Syu # -Syu, no -Sy: evita dejar el sistema en partial upgrade

# -Syu pudo traer un kernel nuevo sin reiniciar: eso rompe docker/nftables más abajo.
if [ ! -d "/usr/lib/modules/$(uname -r)" ]; then
    printf '\n\033[1;33m⚠ El kernel se actualizó (corriendo %s, sin módulos en disco) — reiniciar y volver a correr este script.\033[0m\n' "$(uname -r)"
    printf 'El script es idempotente: lo ya instalado se saltea, así que reiniciar no repite trabajo.\n'
    exit 0
fi

# base + python (no viene garantizado en Arch mínimo, lo necesita coinwatch.py de waybar)
pacman_install git curl wget stow base-devel zip unzip pandoc xdg-utils hwinfo btop python

pacman_install fish starship zoxide fzf ripgrep fd tmux

# Wayland/sway/waybar (--needed hace no-op si ya vienen del perfil "sway" de archinstall)
pacman_install sway waybar wmenu swaybg swayidle gtklock brightnessctl grim playerctl wlogout pamixer matugen mako wl-clipboard

# mako trae su unit systemd --user pero llega deshabilitada: sin esto no arranca solo tras reiniciar.
if ! systemctl --user is-enabled --quiet mako.service 2>/dev/null; then
    log "Habilitando y arrancando mako.service (--user)"
    systemctl --user enable --now mako.service
else
    log "mako.service ya está habilitado"
fi

pacman_install flameshot pavucontrol
pacman_install lazygit   # integración LazyVim <leader>gg, ya trae el bind, falta el binario
pacman_install udisks2 udiskie   # automontaje de pendrives/discos, sway no trae DE

pacman_install fuzzel
# matugen escribe fuzzel.ini aquí (fuzzel no es paquete de stow); sin el dir, la primera corrida tira error.
mkdir -p "$HOME/.config/fuzzel"

pacman_install dbeaver
pacman_install docker docker-compose

if ! systemctl is-enabled --quiet docker.service 2>/dev/null; then
    log "Habilitando y arrancando docker.service"
    sudo systemctl enable --now docker.service
else
    log "docker.service ya está habilitado"
fi

if ! groups "$USER" | grep -qw docker; then
    log "Añadiendo $USER al grupo docker (necesitarás cerrar sesión y volver a entrar)"
    sudo usermod -aG docker "$USER"
else
    log "$USER ya pertenece al grupo docker"
fi

# yazi + deps -- chafa es el fallback de preview cuando la terminal no soporta el protocolo gráfico de kitty
pacman_install yazi ffmpeg 7zip jq poppler resvg imagemagick chafa

pacman_install ttf-fantasque-nerd   # fuente principal: kitty/alacritty/waybar
# fallback: FantasqueSansM no trae el set Material Design -- sin esto el ícono de notificaciones de waybar sale vacío
pacman_install ttf-nerd-fonts-symbols-mono

# rustup/cargo -- eza se instala vía cargo, no pacman
if ! command -v cargo >/dev/null 2>&1; then
    log "Instalando rustup"
    curl https://sh.rustup.rs -sSf | sh -s -- -y
    source "$HOME/.cargo/env"
else
    log "cargo ya está instalado, se omite rustup"
fi

if ! command -v eza >/dev/null 2>&1; then
    log "cargo install eza"
    cargo install eza
else
    log "eza ya está instalado"
fi

pacman_install go

# deps de compilación para pyenv -- sin esto `pyenv install <version>` falla a mitad de build
pacman_install openssl zlib xz bzip2 readline sqlite tk libffi

if [ ! -x "$HOME/.pyenv/bin/pyenv" ]; then
    log "Instalando pyenv"
    curl -fsSL https://pyenv.run | bash
    if [ ! -x "$HOME/.pyenv/bin/pyenv" ]; then
        printf '\033[1;31mpyenv no quedó instalado correctamente (falta ~/.pyenv/bin/pyenv).\033[0m\n' >&2
        exit 1
    fi
else
    log "pyenv ya está instalado"
fi

# kitty -- instalador oficial, no pacman
if ! command -v kitty >/dev/null 2>&1 && [ ! -x "$HOME/.local/kitty.app/bin/kitty" ]; then
    log "Instalando kitty"
    curl -fL https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
    mkdir -p "$HOME/.local/bin" "$HOME/.local/share/applications"
    ln -sf "$HOME/.local/kitty.app/bin/kitty" "$HOME/.local/kitty.app/bin/kitten" "$HOME/.local/bin/"
    cp "$HOME/.local/kitty.app/share/applications/kitty.desktop" "$HOME/.local/share/applications/"
    cp "$HOME/.local/kitty.app/share/applications/kitty-open.desktop" "$HOME/.local/share/applications/"
    sed -i "s|Icon=kitty|Icon=$(readlink -f "$HOME")/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" "$HOME"/.local/share/applications/kitty*.desktop
    sed -i "s|Exec=kitty|Exec=$(readlink -f "$HOME")/.local/kitty.app/bin/kitty|g" "$HOME"/.local/share/applications/kitty*.desktop
    echo 'kitty.desktop' > "$HOME/.config/xdg-terminals.list"
    if [ ! -x "$HOME/.local/bin/kitty" ]; then
        printf '\033[1;31mkitty no quedó instalado correctamente (falta ~/.local/bin/kitty).\033[0m\n' >&2
        exit 1
    fi
else
    log "kitty ya está instalado"
fi

# SDKMAN core -- el plugin de fish (más abajo) es solo un wrapper, necesita esto ya instalado
if [ ! -d "$HOME/.sdkman" ]; then
    log "Instalando SDKMAN"
    curl -fsS "https://get.sdkman.io" | bash
else
    log "SDKMAN ya está instalado"
fi

# fisher + plugins de fish
if ! fish -c 'type -q fisher' >/dev/null 2>&1; then
    log "Instalando fisher y plugins de fish (jorgebucaran/nvm.fish, reitzig/sdkman-for-fish)"
    fish -c 'curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'
    fish -c 'fisher install jorgebucaran/nvm.fish reitzig/sdkman-for-fish'
else
    log "fisher ya está instalado"
fi

if ! command -v claude >/dev/null 2>&1; then
    log "Instalando Claude Code"
    curl -fsSL https://claude.ai/install.sh | bash
else
    log "Claude Code ya está instalado"
fi

# claudebar (uso de Claude en waybar) -- from-source: no hay AUR helper aquí y es un solo paquete
if ! command -v claudebar >/dev/null 2>&1; then
    log "Instalando claudebar"
    claudebar_tmp=$(mktemp -d)
    git clone --depth 1 https://github.com/mryll/claudebar.git "$claudebar_tmp"
    make -C "$claudebar_tmp" install PREFIX="$HOME/.local"
    rm -rf "$claudebar_tmp"
else
    log "claudebar ya está instalado"
fi

log "Verificando instalación"
any_check_failed=0
check() {
    if eval "$2" >/dev/null 2>&1; then
        printf '  \033[1;32m✓\033[0m %s\n' "$1"
    else
        printf '  \033[1;31m✗\033[0m %s\n' "$1"
        any_check_failed=1
    fi
}
check "pyenv"  '"$HOME/.pyenv/bin/pyenv" --version'
check "kitty"  '"$HOME/.local/bin/kitty" --version'
check "docker" 'command -v docker'
check "eza"    'command -v eza'
check "go"     'command -v go'
check "fisher" "fish -c 'type -q fisher'"
check "claude" 'command -v claude'
check "claudebar" 'command -v claudebar'

if [ "$any_check_failed" -eq 1 ]; then
    printf '\n\033[1;31mAlgunas herramientas no quedaron operativas — revisar los logs arriba antes de dar la instalación por buena.\033[0m\n'
fi

log "Listo. Pendiente MANUAL (no lo hace este script):"
cat <<'EOF'
  - nvim (tarball manual, ver README.md > "Comandos")
  - claude (login OAuth interactivo, primera vez): claude

  cd ~/dotfiles && stow -R fish nvim kitty alacritty starship tmux ideavim scripts sway waybar mako wlogout matugen gtklock environment

  - tema inicial (sway/mako/fuzzel): ~/.local/bin/set-wallpaper
  - tema inicial (kitty): kitty +kitten themes kanagawabones
EOF
