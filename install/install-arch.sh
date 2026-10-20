#!/usr/bin/env bash
set -euo pipefail

export LC_ALL=C.UTF-8
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

log() { printf '\n\033[1;34m==> %s\033[0m\n' "$1"; }

on_error() {
    local exit_code=$?
    printf '\n\033[1;31m✗ FALLÓ (línea %s): %s\033[0m\n' "$1" "$2" >&2
    exit "$exit_code"
}
trap 'on_error "$LINENO" "$BASH_COMMAND"' ERR

pacman_install() {
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
sudo pacman -Syu

if [ ! -d "/usr/lib/modules/$(uname -r)" ]; then
    printf '\n\033[1;33m⚠ El kernel se actualizó (corriendo %s, sin módulos en disco) — reiniciar y volver a correr este script.\033[0m\n' "$(uname -r)"
    printf 'El script es idempotente: lo ya instalado se saltea, así que reiniciar no repite trabajo.\n'
    exit 0
fi

pacman_install git curl wget stow base-devel zip unzip pandoc xdg-utils hwinfo btop python

pacman_install fish starship zoxide fzf ripgrep fd tmux

pacman_install net-tools lsof qpdf trivy ufw ncdu

pacman_install chromium clang cmake ninja gtk3 fontconfig pkgconf

pacman_install uv
if ! command -v cli-chess >/dev/null 2>&1; then
    log "uv tool install cli-chess"
    uv tool install cli-chess
else
    log "cli-chess ya está instalado"
fi
"$(dirname "$0")/../scripts/.local/bin/cli-chess-tema" || true

pacman_install sway waybar wmenu swaybg swayidle gtklock brightnessctl grim playerctl wlogout pamixer matugen mako wl-clipboard

if ! systemctl --user is-enabled --quiet mako.service 2>/dev/null; then
    log "Habilitando y arrancando mako.service (--user)"
    systemctl --user enable --now mako.service
else
    log "mako.service ya está habilitado"
fi

pacman_install flameshot pavucontrol
pacman_install lazygit
pacman_install udisks2 udiskie

pacman_install fuzzel
mkdir -p "$HOME/.config/fuzzel"

pacman_install rofi rofi-calc
mkdir -p "$HOME/.config/rofi"

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

pacman_install yazi ffmpeg 7zip jq poppler resvg imagemagick chafa

pacman_install ttf-fantasque-nerd
pacman_install ttf-nerd-fonts-symbols-mono

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

if ! command -v bookokrat >/dev/null 2>&1; then
    log "cargo install bookokrat --locked"
    cargo install bookokrat --locked
else
    log "bookokrat ya está instalado"
fi

pacman_install go

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

if [ ! -d "$HOME/.sdkman" ]; then
    log "Instalando SDKMAN"
    curl -fsS "https://get.sdkman.io" | bash
else
    log "SDKMAN ya está instalado"
fi

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

if ! command -v opencode >/dev/null 2>&1 && [ ! -x "$HOME/.opencode/bin/opencode" ]; then
    log "Instalando opencode"
    curl -fsSL https://opencode.ai/install | bash -s -- --no-modify-path
else
    log "opencode ya está instalado"
fi

pacman_install openai-codex

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
check "opencode" '"$HOME/.opencode/bin/opencode" --version'
check "codex"  'command -v codex'
check "rofi-calc" 'pacman -Q rofi-calc'
check "bookokrat (zen)" 'command -v bookokrat'
check "cli-chess" 'cli-chess --version'
check "Chromium" 'command -v chromium'
check "CMake" 'cmake --version'
check "Ninja" 'ninja --version'

if [ "$any_check_failed" -eq 1 ]; then
    printf '\n\033[1;31mAlgunas herramientas no quedaron operativas — revisar los logs arriba antes de dar la instalación por buena.\033[0m\n'
fi

log "Listo. Pendiente MANUAL (no lo hace este script):"
cat <<'EOF'
  - nvim (tarball manual, ver README.md > "Comandos")
  - claude (login OAuth interactivo, primera vez): claude
  - opencode (login del proveedor, primera vez): opencode auth login
  - codex (login, primera vez): codex login
  - Flutter + Android Studio y adas-cli: ver install/README.md

  cd ~/dotfiles && stow -R fish nvim kitty alacritty starship tmux ideavim scripts sway waybar mako wlogout matugen gtklock environment cli-chess

  - tema inicial (sway/mako/fuzzel): ~/.local/bin/set-wallpaper
  - tema inicial (kitty): kitty +kitten themes kanagawabones
EOF
