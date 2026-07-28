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

pacman_install() {
    log "pacman: $*"
    sudo pacman -S --needed "$@"
}

log "Actualizando índices de paquetes"
sudo pacman -Sy

# --- Base ---------------------------------------------------------------
pacman_install git curl wget stow

# --- Shell / prompt / navegación ----------------------------------------
pacman_install fish starship zoxide fzf ripgrep fd tmux

# --- Terminal multiplexer / lanzador de apps ya cubiertos arriba (tmux) --

# --- Wayland / sway / waybar ---------------------------------------------
# sway y waybar suelen venir con el perfil "sway" de archinstall; --needed
# hace que esto sea un no-op si ya están.
pacman_install sway waybar wmenu swaybg swayidle swaylock brightnessctl grim playerctl

# --- Utilidades de escritorio ---------------------------------------------
pacman_install flameshot

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

# --- pyenv ------------------------------------------------------------------
if [ ! -d "$HOME/.pyenv" ]; then
    log "Instalando pyenv"
    curl -fsSL https://pyenv.run | bash
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
else
    log "kitty ya está instalado"
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

log "Listo. Pendiente MANUAL (no lo hace este script):"
cat <<'EOF'
  - nvim: descargar el tarball, extraer en /opt/nvim (ver README.md > "Comandos").
  - ssh-keygen -t ed25519 -a 100 -C "tu-email" y añadir la key pública a GitHub.
  - git clone git@github.com:AlexanderTemp/dotfiles.git ~/dotfiles (si no lo tienes ya).
  - cd ~/dotfiles && stow -R fish nvim kitty alacritty starship tmux ideavim scripts sway waybar
EOF
