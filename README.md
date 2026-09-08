<h1 style="text-align: center;">🤠 My personal dotfiles customization</h1>
<p align="center">
  <img src="https://img.shields.io/badge/CachyOS%2FArch-1793D1?style=for-the-badge&logo=archlinux&logoColor=white"/>
  <img src="https://img.shields.io/badge/sway-Wayland-blue?style=for-the-badge&logo=wayland&logoColor=white"/>
</p>

![](./assets/dotfiles-img-5.png)
![](./assets/dotfiles-img-4.png)

---

## 🔧 Instalación

Arch/CachyOS + sway únicamente ([SSH keygen](https://docs.github.com/en/authentication/connecting-to-github-with-ssh) primero si se clona por SSH).

```bash
git clone git@github.com:AlexanderTemp/dotfiles.git ~/dotfiles   # SSH, con key ya agregada — para pushear cambios
# git clone https://github.com/AlexanderTemp/dotfiles.git ~/dotfiles  # HTTPS — solo lectura, sin key

cd ~/dotfiles/install
./install-arch.sh   # idempotente — instala todo salvo nvim (manual, ver abajo)

cd ~/dotfiles
stow -R fish nvim kitty alacritty starship tmux ideavim scripts sway waybar mako wlogout matugen gtklock environment

# tema inicial (sway/mako/fuzzel, no vive en el repo — ver Estructura)
~/.local/bin/set-wallpaper

# tema inicial (kitty, tampoco vive en el repo)
kitty +kitten themes kanagawabones
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

El listado completo (con el motivo de cada paquete) vive comentado en [`install/install-arch.sh`](install/install-arch.sh) — es la única fuente de verdad, así no hay dos listas que se desincronicen. Acá solo lo que **no** instala pacman o necesita una nota:

| Herramienta | Nota |
|---|---|
| [nvim](https://neovim.io/) + [LazyVim](https://www.lazyvim.org/) | manual, vía tarball (ver Instalación) |
| [pyenv](https://github.com/pyenv/pyenv) | Python version manager |
| [SDKMAN!](https://sdkman.io/) | JVM version manager (Java/Kotlin/Gradle) |
| [nvm.fish](https://github.com/jorgebucaran/nvm.fish) | Node version manager, plugin de fisher |
| [rustup](https://rustup.rs/) + [eza](https://github.com/eza-community/eza) | eza va por `cargo install`, no por pacman |
| [.NET SDK](https://dotnet.microsoft.com/) / [bun](https://bun.sh/) | manuales — `$DOTNET_ROOT`/`$BUN_INSTALL` ya están en `config.fish` para cuando los instales |
| [claudebar](https://github.com/mryll/claudebar) | uso del plan de Claude en waybar, se compila from-source |
| coinwatch (`waybar/scripts/coinwatch.py`) | precios cripto en waybar, script propio |
| [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) | vendorizado en `tmux/.tmux/plugins/`, no vía TPM |

## 🧭 Uso

- Atajos de teclado y alias: [SHORTCUTS.md](SHORTCUTS.md).
- Para importar los comandos de git usados por mi: [GIT-ALIAS.md](GIT-ALIAS.md).
