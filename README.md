<h1 style="text-align: center;">🤠 My personal dotfiles customization</h1>
<p align="center">
  <img src="https://img.shields.io/badge/Debian-13-A81D33?style=for-the-badge&logo=debian&logoColor=white"/>
  <img src="https://img.shields.io/badge/Ubuntu-24.04-E95420?style=for-the-badge&logo=ubuntu&logoColor=white"/>
  <img src="https://img.shields.io/badge/Linux%20Mint-22-87CF3E?style=for-the-badge&logo=linuxmint&logoColor=white"/>
</p>

![](./assets/dotfiles-img.png)

---

## 📦 Estructura

Cada carpeta es un paquete de [stow](https://www.gnu.org/software/stow/): la ruta de adentro es la misma que va a tener en `$HOME`. Así puedo instalar o actualizar uno sin tocar los demás.

```
dotfiles/
├── fish/        -> ~/.config/fish
├── nvim/        -> ~/.config/nvim
├── kitty/       -> ~/.config/kitty
├── alacritty/   -> ~/.config/alacritty
├── starship/    -> ~/.config/starship.toml
├── tmux/        -> ~/.tmux, ~/.tmux.conf
├── ideavim/     -> ~/.ideavimrc
└── scripts/     -> ~/docker-ps-visual.sh, ~/toggle-kitty
```

Para instalar o actualizar todo de una:

```bash
cd ~/dotfiles
stow -R fish nvim kitty alacritty starship tmux ideavim scripts
```

## 💽 Pre install

Instala las siguientes herramientas para que los dotfiles funcionen correctamente.

- [stow](https://www.gnu.org/software/stow/) Symlink dotfiles manager.
- [fish](https://software.opensuse.org/download.html?project=shells%3Afish%3Arelease%3A4&package=fish) CLI shell para linux.
- [starship](https://starship.rs/) Prompt customizer.
- [zoxide](https://github.com/ajeetdsouza/zoxide) `cd` inteligente, usado en `config.fish`.
- [fisher](https://github.com/jorgebucaran/fisher) Plugin manager de fish. Instala también el plugin `jorgebucaran/nvm.fish` (ver `fish/.config/fish/fish_plugins`).
- [eza](https://github.com/eza-community/eza) Reemplazo de `ls` usado en los alias `lf`/`la`/`ll`/`qw`. **Instálalo con `cargo install eza`**, no con `apt` — la versión de los repos de Debian suele estar desactualizada o dar conflictos.
- [ripgrep](https://github.com/BurntSushi/ripgrep) (`rg`) y [fd-find](https://github.com/sharkdp/fd) (alias `fd="fdfind"`).
- [kitty](https://sw.kovidgoyal.net/kitty/binary/) Terminal emulator basado en GPU.
- [alacritty](https://alacritty.org/) Terminal emulator alternativo, config en `alacritty/`.
- [cargo](https://doc.rust-lang.org/cargo) Rust y su gestor de paquetes.
- [bun](https://bun.sh/) Runtime/paquetería de JS, usado vía `$BUN_INSTALL`.
- [nvm](https://github.com/nvm-sh/nvm) Node version manager (integrado como plugin de fish).
- [pyenv](https://github.com/pyenv/pyenv) Python version manager, inicializado en `config.fish`.
- [.NET SDK](https://dotnet.microsoft.com/) usado vía `$DOTNET_ROOT`.
- [tmux](https://github.com/tmux/tmux/wiki/Installing) Terminal multiplexer.
- [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) Guarda y restaura sesiones de tmux (ver sección de abajo).
- [nvim](https://github.com/neovim/neovim/releases) Editor de texto basado en Vim.
- [lazyvim](https://www.lazyvim.org/) Customizador para nvim.

## 🖥️ Sesiones dinámicas (resurrect con nombre)

Sin tmuxifier, sin auto-guardado. Armas la sesión a mano (paneles, ventanas, programas corriendo) y cuando te gusta cómo quedó, la guardas con nombre. Los snapshots viven en `~/.tmux/resurrect/named/*.txt` (local, no se commitean).

| Acción | Atajo |
|---|---|
| Guardar sesión actual con nombre | `prefix S` (pide el nombre) |
| Cargar un layout guardado | `prefix L` (popup con fzf para elegir) |
| Guardar el último snapshot (sin nombre) | `prefix Ctrl-s` |
| Restaurar el último snapshot (sin nombre) | `prefix Ctrl-r` |

Flujo típico:
```
1. Abre tmux, arma paneles/ventanas/programas como quieras.
2. prefix S -> escribe un nombre, ej. "backend".
3. La próxima vez: abre tmux, prefix L, elige "backend".
```

## ⌨️ tmux — chuleta rápida

Prefix = `Ctrl-a`

| Acción | Atajo |
|---|---|
| Split horizontal | `prefix s` |
| Split vertical | `prefix x` |
| Moverse entre paneles | `prefix h/j/k/l` |
| Recargar config | `prefix r` |
| Buscador de sesiones (fzf) | `prefix Ctrl-j` |
| Nueva sesión con nombre | `prefix Ctrl-n` |

## 🔧 Instalación

```bash
git clone <este-repo> ~/dotfiles
cd ~/dotfiles
stow fish nvim kitty alacritty starship tmux ideavim scripts
```

Cada nombre es opcional: puedes correr `stow <paquete>` solo para lo que quieras instalar, o `stow -D <paquete>` para desinstalarlo (quita los symlinks sin borrar el contenido del repo).

## 🧑‍💻 Comandos para Debian 13

Ya tengo los comandos para instalar cada herramienta correctamente en Debian.

```bash
# base installation
sudo apt update 
sudo apt install curl wget git tar gzip xz-utils build-essential cmake pkg-config ca-certificates lsb-release ripgrep fd-find fzf libevent ncurses

# Stow y Fish 
sudo apt install vim 
sudo apt install stow
sudo apt install tmux
suto apt install ./fish**.deb
curl -sS https://starship.rs/install.sh | s


# Kitty config
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
echo 'kitty.desktop' > ~/.config/xdg-terminals.list

# Cargo
curl https://sh.rustup.rs -sSf | sh

# eza (via cargo, no apt)
cargo install eza

# NVM (la integración con el shell ya la maneja el plugin de fish)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash

# nvim, una vez descargada la última versión
sudo rm -rf /opt/nvim-***-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
# el PATH ya lo maneja fish, carpeta recomendada "/opt/nvim"
```
