<h1 style="text-align: center;">🤠 My personal dotfiles customization</h1>
<p align="center">
  <img src="https://img.shields.io/badge/CachyOS%2FArch-1793D1?style=for-the-badge&logo=archlinux&logoColor=white"/>
  <img src="https://img.shields.io/badge/sway-Wayland-blue?style=for-the-badge&logo=wayland&logoColor=white"/>
</p>

![](./assets/dotfiles-img-5.png)
![](./assets/dotfiles-img-4.png)

---

## 🔧 Instalación

Arch/CachyOS + sway únicamente ([SSH keygen](https://docs.github.com/en/authentication/connecting-to-github-with-ssh) primero si clonás por SSH).

```bash
git clone git@github.com:AlexanderTemp/dotfiles.git ~/dotfiles   # SSH, con key ya agregada — para pushear cambios
# git clone https://github.com/AlexanderTemp/dotfiles.git ~/dotfiles  # HTTPS — solo lectura, sin key

cd ~/dotfiles/install
./install-arch.sh   # idempotente — instala todo salvo nvim (manual, ver abajo)

cd ~/dotfiles
stow -R fish nvim kitty alacritty starship tmux ideavim scripts sway waybar mako wlogout matugen gtklock environment

# tema inicial: matugen genera sway/config.d/colors, mako/colors,
# matugen/colors.css y ~/.config/fuzzel/fuzzel.ini (ninguno vive en el
# repo — ver sección Estructura). sway/config incluye colors a mano, así
# que hace falta esto antes del primer arranque de sway.
~/.local/bin/set-wallpaper   # elegí el único wallpaper listado
```

```bash
# nvim: único paso manual
sudo rm -rf /opt/nvim-***-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
```

`stow <paquete>` instala uno solo, `stow -D <paquete>` lo desinstala. **Nunca `stow .`** — rompe las rutas (`~/fish` en vez de `~/.config/fish`).

## 📦 Estructura

Cada carpeta es un paquete de [stow](https://www.gnu.org/software/stow/): la ruta de adentro es la misma que va a tener en `$HOME`. Así puedo instalar o actualizar uno sin tocar los demás.

```
dotfiles/
├── fish/        -> ~/.config/fish
├── nvim/        -> ~/.config/nvim
├── kitty/       -> ~/.config/kitty
├── alacritty/   -> ~/.config/alacritty
├── starship/    -> ~/.config/starship.toml
├── sway/        -> ~/.config/sway
├── waybar/      -> ~/.config/waybar
├── mako/        -> ~/.config/mako
├── wlogout/     -> ~/.config/wlogout
├── matugen/     -> ~/.config/matugen
├── gtklock/     -> ~/.config/gtklock
├── tmux/        -> ~/.tmux, ~/.tmux.conf
├── ideavim/     -> ~/.ideavimrc
├── environment/ -> ~/.config/environment.d
└── scripts/     -> ~/docker-ps-visual.sh, ~/.local/bin/set-wallpaper
```

`wallpapers/` e `install/` no son paquetes de stow: el primero se referencia por ruta directa, el segundo son scripts de bootstrap de una sola vez (ver arriba). `wallpapers/` guarda un único wallpaper default (`higuruma-jujutsu-kaisen.png`); `set-wallpaper` (`$mod+Shift+w`) permite usar cualquier otra imagen que se copie ahí a mano, elegible con fuzzel.

`fuzzel/` tampoco es paquete: no tiene fuente propia, `~/.config/fuzzel/fuzzel.ini` lo escribe matugen por completo (junto con `sway/config.d/colors`, `mako/colors` y `matugen/colors.css`). Estos 4 archivos están en `.gitignore` a propósito — cambian con cada wallpaper elegido, así que trackearlos generaba conflicto en cada `git pull`.

Mismo motivo para `kitty/.config/kitty/current-theme.conf` y `past-current-theme.conf` (los regenera `kitty +kitten themes` al elegir tema): también en `.gitignore`, nunca son fuente.

## 🧰 Herramientas

| Herramienta | Descripción |
|---|---|
| [nvim](https://neovim.io/) | editor — manual, ver arriba |
| [LazyVim](https://www.lazyvim.org/) | config base de nvim |
| [tmux](https://github.com/tmux/tmux) | multiplexer, prefix `Ctrl-a` |
| [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) | guarda sesiones, vendorizado |
| [fish](https://fishshell.com/) | shell interactivo |
| [fisher](https://github.com/jorgebucaran/fisher) | plugins fish (`nvm.fish`, `sdkman-for-fish`) |
| [sway](https://swaywm.org/) | compositor Wayland tiling |
| [kitty](https://sw.kovidgoyal.net/kitty/) | terminal GPU |
| [alacritty](https://alacritty.org/) | terminal alternativa |
| [docker](https://www.docker.com/) + compose | contenedores |
| [cargo/rustup](https://rustup.rs/) | Rust y su gestor |
| [pyenv](https://github.com/pyenv/pyenv) | Python version manager |
| [nvm](https://github.com/nvm-sh/nvm) | Node, plugin `nvm.fish` |
| [SDKMAN!](https://sdkman.io/) | JVM version manager |
| [.NET SDK](https://dotnet.microsoft.com/) | vía `$DOTNET_ROOT` |
| [Go](https://go.dev/) | PATH en `config.fish` |
| [bun](https://bun.sh/) | runtime JS, `$BUN_INSTALL` |
| [dbeaver](https://dbeaver.io/) | cliente SQL |
| [Claude Code](https://claude.com/claude-code) | CLI de IA |
| [claudebar](https://github.com/mryll/claudebar) | uso de Claude en waybar, from-source |
| coinwatch (`waybar/scripts/coinwatch.py`) | precios cripto en waybar, script propio |
| [yazi](https://github.com/sxyazi/yazi) | file manager TUI, vía `yazi.nvim` |
| [starship](https://starship.rs/) | prompt |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | `cd` inteligente |
| [eza](https://github.com/eza-community/eza) | reemplazo `ls`, alias `lf/la/ll/qw` |
| [ripgrep](https://github.com/BurntSushi/ripgrep) (`rg`) | grep rápido |
| [fd](https://github.com/sharkdp/fd) | find rápido |
| [fzf](https://github.com/junegunn/fzf) | fuzzy finder |
| [waybar](https://github.com/Alexays/Waybar) | barra de estado |
| [mako](https://mako-project.org) | notificaciones, coloreado por matugen |
| [fuzzel](https://codeberg.org/dnkl/fuzzel) | lanzador de apps |
| [wmenu](https://codeberg.org/adnano/wmenu) | lanzador alt, backup fuzzel |
| [matugen](https://github.com/InioX/matugen) | paleta desde wallpaper, `$mod+Shift+w` |
| [gtklock](https://github.com/jovanlanik/gtklock) | pantalla de bloqueo |
| [wlogout](https://github.com/ArtsyMacaw/wlogout) | menú de sesión, `$mod+Shift+e` |
| [flameshot](https://flameshot.org/) | capturas con anotaciones |
| [pavucontrol](https://freedesktop.org/software/pulseaudio/pavucontrol/) | mixer de audio |
| [FantasqueSansM Nerd Font](https://www.nerdfonts.com/) | fuente principal |
| [Symbols Nerd Font Mono](https://github.com/ryanoasis/nerd-fonts) | fallback íconos waybar |
| swayidle, swaybg, grim, playerctl, pamixer, brightnessctl | utilidades de keybinds sway |
| [stow](https://www.gnu.org/software/stow/) | symlink manager |

## 🧭 Uso

- Atajos de teclado y alias: [SHORTCUTS.md](SHORTCUTS.md).
- Para importar los comandos de git usados por mi: [GIT-ALIAS.md](GIT-ALIAS.md).
