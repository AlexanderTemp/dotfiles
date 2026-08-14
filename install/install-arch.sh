#!/usr/bin/env bash
# Bootstrap de paquetes para una instalación limpia de Arch/CachyOS (pacman).
# Deliberadamente NO instala nvim: eso se hace a mano vía tarball (ver README.md).
#
# Uso:
#   cd ~/dotfiles/install
#   ./install-arch.sh
#
# No es un paquete de stow: vive fuera de $HOME y solo se ejecuta una vez
# (o cuando se reinstala la máquina), no se re-corre en cada `stow -R`.

set -euo pipefail

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
    printf '\n\033[1;33m⚠ El kernel se actualizó (corriendo %s, sin módulos en disco) — reiniciá y volvé a correr este script.\033[0m\n' "$(uname -r)"
    printf 'El script es idempotente: lo ya instalado se saltea, así que reiniciar no repite trabajo.\n'
    exit 0
fi

# --- Base ---------------------------------------------------------------
pacman_install git curl wget stow base-devel zip unzip pandoc xdg-utils hwinfo btop

# --- Shell / prompt / navegación ----------------------------------------
pacman_install fish starship zoxide fzf ripgrep fd tmux

# --- Terminal multiplexer / lanzador de apps ya cubiertos arriba (tmux) --

# --- Wayland / sway / waybar ---------------------------------------------
# sway y waybar suelen venir con el perfil "sway" de archinstall; --needed
# hace que esto sea un no-op si ya están.
pacman_install sway waybar wmenu swaybg swayidle gtklock brightnessctl grim playerctl wlogout pamixer matugen

# --- Utilidades de escritorio ---------------------------------------------
pacman_install flameshot pavucontrol

# --- fuzzel (lanzador de aplicaciones) --------------------------------------
if ! command -v fuzzel >/dev/null 2>&1; then
    log "Instalando fuzzel"
    pacman_install fuzzel
else
    log "fuzzel ya está instalado"
fi

# --- dbeaver (cliente SQL) ---------------------------------------------------
if ! command -v dbeaver >/dev/null 2>&1; then
    log "Instalando dbeaver"
    pacman_install dbeaver
else
    log "dbeaver ya está instalado"
fi

# --- docker -------------------------------------------------------------------
if ! command -v docker >/dev/null 2>&1; then
    log "Instalando docker"
    pacman_install docker docker-compose
else
    log "docker ya está instalado"
fi

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

# --- Yazi y sus dependencias ------------------------------------------------
pacman_install yazi ffmpeg 7zip jq poppler resvg imagemagick

# --- Fuente usada en kitty/alacritty/waybar (FantasqueSansM Nerd Font) ----
pacman_install ttf-fantasque-nerd

# --- Rust / cargo (necesario para eza: NO instalar eza vía pacman) ---------
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

# --- Go -----------------------------------------------------------------------
pacman_install go

# --- pyenv --------------------------------------------------------------------
# Deps de compilación: sin esto `pyenv install <version>` falla a mitad de
# build (openssl/zlib/etc faltantes) aunque pyenv en sí se haya instalado bien.
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

# --- kitty (instalador oficial, no pacman) -----------------------------------
if ! command -v kitty >/dev/null 2>&1 && [ ! -x "$HOME/.local/kitty.app/bin/kitty" ]; then
    log "Instalando kitty"
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
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

# --- SDKMAN (core) --------------------------------------------------------------
# El plugin de fish (reitzig/sdkman-for-fish, más abajo) es solo un wrapper:
# necesita que esto ya esté instalado, si no cada `sdk` tira el warning de
# "installation path set but no installation found there".
if [ ! -d "$HOME/.sdkman" ]; then
    log "Instalando SDKMAN"
    curl -s "https://get.sdkman.io" | bash
else
    log "SDKMAN ya está instalado"
fi

# --- fisher + plugins de fish -------------------------------------------------
if ! fish -c 'type -q fisher' >/dev/null 2>&1; then
    log "Instalando fisher y plugins de fish (jorgebucaran/nvm.fish, reitzig/sdkman-for-fish)"
    fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'
    fish -c 'fisher install jorgebucaran/nvm.fish reitzig/sdkman-for-fish'
else
    log "fisher ya está instalado"
fi

# --- Claude Code CLI -----------------------------------------------------------
if ! command -v claude >/dev/null 2>&1; then
    log "Instalando Claude Code"
    curl -fsSL https://claude.ai/install.sh | bash
else
    log "Claude Code ya está instalado"
fi

# --- Verificación final -------------------------------------------------------
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

if [ "$any_check_failed" -eq 1 ]; then
    printf '\n\033[1;31mAlgunas herramientas no quedaron operativas — revisá los logs arriba antes de dar la instalación por buena.\033[0m\n'
fi

log "Listo. Pendiente MANUAL (no lo hace este script):"
cat <<'EOF'
  - nvim: descargar el tarball, extraer en /opt/nvim (ver README.md > "Comandos").
  - ssh-keygen -t ed25519 -a 100 -C "tu-email" y añadir la key pública a GitHub.
  - git clone git@github.com:AlexanderTemp/dotfiles.git ~/dotfiles (si no lo tienes ya).
  - cd ~/dotfiles && stow -R fish nvim kitty alacritty starship tmux ideavim scripts sway waybar fuzzel wlogout matugen gtklock environment
EOF
