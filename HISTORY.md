# Historial de instalación limpia (2026-07-28, Arch/CachyOS)

Este archivo documenta lo que realmente hubo que instalar en la última
instalación limpia, reconstruido desde `~/.local/share/fish/fish_history`.
`install/install-arch.sh` encapsula el resultado de este contraste; este
documento es el "por qué".

## Migración: Debian/Ubuntu/Mint quedan deprecados, todo pasa a Arch/sway

Decisión explícita: de acá en adelante se trabaja únicamente en Arch/CachyOS
con sway, no más Debian ni Ubuntu. Como consecuencia:

- Se sacaron del `README.md` los badges y la sección de comandos de
  Debian/Ubuntu/Mint (apt, `fish**.deb`, etc.) — la única vía de instalación
  documentada ahora es `install/install-arch.sh`.
- Se borró de `fish/.config/fish/config.fish` el `alias fd="fdfind"`: era un
  workaround exclusivo de Debian/Ubuntu (ahí el paquete `fd-find` instala el
  binario como `fdfind` para no chocar con otro paquete); en Arch el binario
  ya se llama `fd`, así que el alias estaba roto en esta máquina
  (`fdfind not found`) y ya no hace falta condicionarlo por distro.
- Se sacó la fila correspondiente de `SHORTCUTS.md` y el ítem de "Add debian
  customization" de `TODO.md`.
- El badge/ítem "Arch/CachyOS" que se había agregado como una opción más
  ahora es la única plataforma soportada.

Lo que sigue abajo es el detalle histórico de la instalación limpia que
motivó todo esto (útil si algún día se vuelve a hacer un setup desde cero).

## Fuente estandarizada: FantasqueSansM Nerd Font Mono

El `waybar/style.css` copiado inicialmente traía `font-family: "Iosevka
Term"` (venía de una config de otro lado). El usuario ya usa
`FantasqueSansM Nerd Font Mono` en kitty (`kitty/.config/kitty/kitty.conf`,
`font_family family="FantasqueSansM Nerd Font Mono"`) y una variante
(`FantasqueSansM Nerd Font Propo`) en alacritty — así que se corrigió
waybar para usar la misma familia y quedar consistente en las tres. La
fuente ya estaba instalada en esta máquina (`ttf-fantasque-nerd`,
paquete `nerd-fonts` de Arch); `install-arch.sh` la pide explícitamente en
vez de `ttc-iosevka`.

## Otros contrastes encontrados en el historial real

- **Gestor de paquetes**: pacman (CachyOS). `sway`, `waybar`, `wmenu`,
  `swaybg`, `grim` y `playerctl` ya venían instalados (probablemente por el
  perfil "sway" de `archinstall`), nunca aparecen como `pacman -S` en el
  historial.
- **nvm**: existía un paso en el historial para instalar `nvm` standalone
  vía curl, pero
  `fish/.config/fish/fish_plugins` en realidad usa el plugin de fisher
  `jorgebucaran/nvm.fish` — y en esta máquina `nvm` standalone **no está
  instalado** (`nvm not found`), solo el plugin. El script nuevo instala
  fisher + `nvm.fish` en vez de nvm standalone.
- **`bun` y `.NET`**: `config.fish` exporta `BUN_INSTALL` y `DOTNET_ROOT` y
  los agrega a `fish_user_paths`, pero ninguno de los dos está instalado en
  esta máquina limpia (`bun not found`, `dotnet not found`). No están en
  `install-arch.sh` — parecen configuración para cuando se necesiten, no
  parte del set base.

## Cosas que faltan instalar para que el sway/waybar nuevos funcionen del todo

El `config` de sway que se copió al repo referencia binarios que **no están
instalados** en esta máquina limpia:

- `swayidle` (bloqueo/apagado automático de pantalla) — no instalado.
- `swaylock` (usado por swayidle para bloquear) — no instalado.
- `brightnessctl` (binds de brillo `XF86MonBrightness*`) — no instalado.

Sin estos tres, esos bindings del `config` simplemente no van a hacer nada.
Ya están agregados a `install/install-arch.sh`.

## Auditoría de `install-arch.sh`: gaps encontrados antes de reinstalar (2026-07-28)

Al revisar el script contra lo que los dotfiles realmente usan, aparecieron
cuatro huecos que habrían hecho sufrir de nuevo en la próxima instalación
limpia — se corrigieron directo en `install-arch.sh`:

- **`zip`/`unzip` faltaban.** El `7zip` que ya se instala (para yazi) da el
  binario `7z`, no `zip`/`unzip`. El instalador de SDKMAN (`get.sdkman.io`)
  chequea explícitamente `command -v zip`/`unzip` y aborta sin ellos.
- **SDKMAN solo estaba a medias.** El script instalaba el plugin de fish
  (`reitzig/sdkman-for-fish`, vía fisher) pero nunca el SDKMAN real (el
  `curl -s https://get.sdkman.io | bash`). Quedaba diferido a la primera vez
  que corrieras `sdk` a mano, vía el prompt interactivo de
  `fish/.config/fish/functions/sdk.fish` — que además habría fallado por el
  punto anterior. Ahora el script instala SDKMAN core explícitamente antes
  del plugin de fish.
- **`base-devel` no estaba.** `cargo install eza` necesita un linker C
  (`cc`); sin `base-devel` falla con `linker `cc` not found` en una máquina
  realmente limpia (dependía de si el perfil de `archinstall` lo traía o
  no).
- **Deps de compilación de pyenv faltaban.** `pyenv` en sí se instala bien,
  pero `pyenv install <versión>` para compilar un Python real necesita
  `openssl zlib xz bzip2 readline sqlite tk libffi` — sin esto falla a
  mitad de build. Es un gap clásico y documentado de pyenv en Arch.

## Cosas específicas de esta máquina (revisar si cambiás de equipo)

- `sway/.config/sway/config`: `output DP-1 mode 1920x1080@60Hz` — nombre de
  salida fijo, hay que ajustarlo si el monitor/puerto cambia.

## Wallpapers movidos a `wallpapers/` para que viajen con el repo

Los 3 wallpapers vivían en `~/Downloads/wallpaper_{1,2,3}.{jpg,png}` —
fuera del repo y de `~/.config`, así que no viajaban con los dotfiles. Se
movieron a `wallpapers/` en la raíz del repo (fuera de cualquier paquete de
stow, como `assets/`, y listado en `.stow-local-ignore` como red de
seguridad). `sway/.config/sway/config` ahora apunta directo a
`~/dotfiles/wallpapers/wallpaper_2.png` en vez de `~/Downloads/...` — asume
que el repo está clonado en `~/dotfiles`.

## Cronología real (resumida de fish_history, en orden)

1. `cp /etc/sway/config ./sway/config` — backup del config default de sway
   como punto de partida.
2. `pacman -S git`
3. Instalación de kitty vía instalador curl (no pacman) + symlinks a
   `~/.local/bin` + `.desktop` + `xdg-terminals.list`.
4. `pacman -S flameshot`
5. `pacman -S yazi ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick`
6. `pacman -S swaybg` (después de notar con `which swaybg` que faltaba, para
   poder fijar el wallpaper a mano con `swaybg -i ... -m fill`).
7. `curl -fsSL https://claude.ai/install.sh | bash` — Claude Code.
8. `ssh-keygen -t ed25519 -a 100 -C "aaalex2025@gmail.com"` + clonar
   `git@github.com:AlexanderTemp/dotfiles.git`.
9. `pacman -S stow starship zoxide ripgrep fd tmux`
10. `curl https://sh.rustup.rs -sSf | sh` (rustup/cargo, para poder instalar
    `eza` con cargo, no con pacman).
11. `curl ... nvm-sh/nvm ... install.sh | bash` — este paso quedó
    **superado**: lo que realmente se usa es el plugin `nvm.fish` (ver
    contraste arriba), no hace falta correrlo tal cual en la próxima
    instalación limpia.
12. `curl -fsSL https://pyenv.run | bash`
13. `pacman -S tmux` (repetido, ya estaba en el paso 9 — quedó duplicado en
    el historial real, dato curioso de cómo fue la sesión).
14. nvim: tarball descargado a mano, extraído y movido a `/opt/nvim`
    (excluido a propósito de `install-arch.sh`, como pediste).
15. `stow -R fish nvim kitty alacritty starship tmux ideavim scripts` para
    activar los dotfiles ya clonados.

## Qué quedó fuera de `install-arch.sh` a propósito

- **nvim** — pedido explícito: se instala aparte por tarball.
- **`eza` vía pacman** — Arch sí tiene `eza` actualizado en sus repos, pero
  el script sigue usando `cargo install eza` para no depender de si el
  paquete de turno está al día. Si preferís la versión de pacman, es un
  cambio de una línea en el script.
- **ssh-keygen** — generar una key nueva es una acción sensible (podría
  pisar una existente); queda como paso manual documentado, no automatizado.
- **bun / dotnet** — referenciados en `config.fish` pero no usados aún en
  esta máquina; no se instalan hasta que los necesites.
