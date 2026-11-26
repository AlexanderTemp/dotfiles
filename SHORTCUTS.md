# Shortcuts

Referencia de todos los atajos de teclado, alias y funciones configurados en este repo de dotfiles. No se symlinkea (ver `.stow-local-ignore`), pero el script `atajos` lee sus tablas para mostrar el menú buscable (`$mod+F1` en sway, o `atajos` en la terminal). Actualizar manualmente si cambian los configs.

## sway (`sway/.config/sway/config.d/keybinds`)

`$mod` es **Super**. Direcciones: `h/j/k/l` o flechas.

| Atajo | Acción |
|---|---|
| `Super+F1` | este menú de atajos |
| `Super+Return` | terminal (kitty) |
| `Super+d` | lanzador de apps (fuzzel) |
| `Super+x` | navegador (firefox) |
| `Super+c` | calculadora (calc-menu) |
| `Super+p` | historial del portapapeles |
| `Super+o` | cambiar salida de audio |
| `Super+Shift+q` | cerrar ventana |
| `Super+Shift+c` | recargar config de sway |
| `Super+Shift+e` | menú de apagado (wlogout) |
| `Super+Shift+w` | cambiar fondo de pantalla |
| `Super+h/j/k/l` | mover foco entre ventanas |
| `Super+Shift+h/j/k/l` | mover ventana |
| `Super+1..0` | ir al workspace 1..10 |
| `Super+Shift+1..0` | mandar ventana al workspace 1..10 |
| `Super+b` / `Super+v` | próxima ventana se abre al lado / debajo |
| `Super+s` / `Super+w` / `Super+e` | layout apilado / pestañas / alternar split |
| `Super+f` | pantalla completa |
| `Super+Shift+Espacio` | alternar ventana flotante |
| `Super+Espacio` | alternar foco entre flotantes y en mosaico |
| `Super+a` | enfocar contenedor padre |
| `Super+Shift+-` / `Super+-` | mandar al scratchpad / mostrar scratchpad |
| `Super+r` | modo redimensionar (h/j/k/l, Enter o Esc para salir) |
| `Super+arrastrar` | mover ventana flotante (clic der. redimensiona) |
| `Print` | captura con flameshot |
| `Shift+Print` | captura de región al portapapeles |

## fzf en fish (`fish/.config/fish/config.fish`)

| Atajo | Acción |
|---|---|
| `Ctrl+T` | buscar archivo y pegar su ruta en la línea actual |
| `Ctrl+R` | buscar en todo el historial de comandos |
| `Alt+C` | buscar carpeta y entrar en ella |

## fish (`fish/.config/fish/conf.d/aliases.fish`)

| Comando | Equivale a | Descripción |
|---|---|---|
| `g` | `git` | atajo corto |
| `ga` | `git add .` | stage todo |
| `gac <mensaje>` | `git add . && git commit -m "<mensaje>"` | stage + commit en un paso |
| `claude`, `cl` | `claude` | abre Claude Code sin el diálogo de confianza de carpeta |
| `d` | `docker` | atajo corto |
| `x` | `exit` | salir de la shell |
| `ii` | `npm install` | |
| `dev` | `npm run dev` | |
| `v`, `nv` | `nvim` | abrir editor |
| `zen [archivo] [opciones]` | `bookokrat` | lector EPUB/PDF/DJVU; también funciona sin archivo para abrir la biblioteca |
| `cli-chess` | `cli-chess` | ajedrez en terminal, instalado con `uv tool` |
| `rgf` | `rg --files \| rg` | filtrar listado de archivos con ripgrep |
| `ff` | `fzf --preview 'bat ...'` | buscador interactivo de archivos con vista previa del contenido |
| `eff` | `nvim (ff)` | buscar archivo con fzf y abrirlo en nvim |
| `open <archivo>` | `xdg-open` en segundo plano | abrir con la app predeterminada sin bloquear la terminal |
| `fip <host> <puertos>` | `ssh -f -N -L p:localhost:p host` | túnel SSH: trae puertos del servidor a localhost |
| `lip` | `pgrep -af "ssh.*-L"` | listar túneles SSH activos |
| `dip <puertos>` | `pkill -f "ssh.*-L p:..."` | cerrar túneles SSH |
| `..` / `...` / `....` | `cd ..` / `cd ../..` / `cd ../../..` | subir 1, 2 o 3 carpetas |
| `atajos` | `fzf` sobre SHORTCUTS.md | buscar entre todos los atajos y comandos |
| `ls`, `lf` | `eza --group-directories-first --icons --git` | listado normal (fallback nativo `ls` si no hay `eza`) |
| `la` | `eza -lah --group-directories-first --icons --git` | listado detallado + ocultos (fallback `ls -lah --color=auto`) |
| `ll` | `eza -lh --group-directories-first --icons --git` | listado detallado (fallback `ls -lh --color=auto`) |
| `qw [n=10]` | `eza -lah --sort=modified --reverse --icons=always --color=always --git \| head -n $n` | últimos *n* archivos modificados (fallback `ls -laht --color=always \| head -n $n`) |
| `dps` | `~/docker-ps-visual.sh` | contenedores corriendo, vista detallada |
| `dpr` | `~/docker-ps-visual.sh -r` | resumen agrupado por estado |
| `dpa` | `~/docker-ps-visual.sh -a` | incluye contenedores detenidos |
| `dpar` | `~/docker-ps-visual.sh -a -r` | resumen + detenidos |
| `t` | `tmux` | |
| `tn <nombre>` | `tmux new -s <nombre>` | nueva sesión tmux con nombre |
| `tw <nombre>` | `tmux new-window -n <nombre>` | nueva ventana tmux con nombre |

`cd` está reemplazado por `zoxide init fish --cmd cd` (si `zoxide` está instalado): aprende directorios frecuentes y agrega `cdi` (selector interactivo fzf) y `cd -` mejorado. Si no hay `zoxide`, `cd` queda como el nativo de fish.

`zen` vive en `fish/.config/fish/functions/zen.fish`: Fish lo carga automáticamente y pasa todos los argumentos a Bookokrat, incluidos nombres con espacios. Para abrir directamente un libro sin paneles: `zen "mi libro.epub" --zen-mode`. La ayuda del lector está en `zen --help` y en `?` dentro de la app; para PDF/DJVU conviene Kitty.

`mdpreview archivo.md` convierte un Markdown con Pandoc y abre la vista HTML en el navegador.

## tmux (`tmux/.tmux.conf`)

Prefix: **`Ctrl-a`** (el default `Ctrl-b` está deshabilitado).

| Atajo | Acción |
|---|---|
| `prefix r` | recargar config (con mensaje de confirmación) |
| `prefix Ctrl-n` | pedir nombre y crear nueva sesión |
| `prefix Ctrl-j` | popup fzf con lista de sesiones, cambiar a la elegida |
| `prefix s` | split horizontal (en la carpeta del panel actual) |
| `prefix c` | split vertical (en la carpeta del panel actual) |
| `prefix v` | nueva ventana (en la carpeta del panel actual) |
| `prefix x` | copy-mode (vi) |
| `y` / arrastrar mouse (en copy-mode) | copiar selección al portapapeles (`wl-copy`) |
| `prefix h/j/k/l` | navegar entre panes (estilo vim) |
| `prefix Alt-s` | tmux-resurrect: guardar snapshot "last" |
| `prefix Alt-r` | tmux-resurrect: restaurar la última sesión guardada |
| `prefix S` | guardar layout **con nombre** (`save-named.sh`) → `~/.tmux/resurrect/named/<nombre>.txt` |
| `prefix L` | popup fzf para cargar un layout con nombre (`load-named.sh`) |
| `prefix Espacio` | tmux-which-key: menú de acciones; `m` abre "My shortcuts" (definido en `tmux/.tmux/plugins/tmux-which-key/config.yaml`) |
| `prefix p` | tmux-floax: mostrar/ocultar panel flotante |
| `prefix P` | tmux-floax: menú del panel flotante (tamaño, pantalla completa, embeber) |

Plugins vendorizados en `tmux/.tmux/plugins/`: `tpm`, `tmux-sensible`, `vim-tmux-navigator`, `rose-pine`, `tmux-resurrect`, `tmux-which-key`, `tmux-floax`.

## nvim (`nvim/.config/nvim/`)

Base LazyVim. Leader: **`<Space>`**.

| Atajo | Acción |
|---|---|
| `<leader>wj` | split horizontal |
| `<leader>wl` | split vertical |
| `<leader>wc` | cerrar ventana actual |
| `<C-h>/<C-j>/<C-k>/<C-l>` | mover foco entre splits |
| `<C-d>/<C-u>/<C-f>/<C-b>` | scroll centrado (`zz`) |
| `<leader>q` | cerrar buffer (snacks.bufdelete) |
| `<leader>?` | which-key popup |
| `zk` / `Zk` (n/x/o) | flash.jump / flash.treesitter (reemplaza `s`/`S` nativos) |
| `<leader>n` | abrir Yazi (file manager) en archivo actual |
| `<leader>cw` | abrir Yazi en cwd de nvim |
| `<C-Up>` | toggle última sesión de Yazi |
| `<leader>mdn` / `<leader>mds` | Markdown preview start/stop |
| `<leader>jk` | Telescope find_files (con ocultos, excluye `.git`) |
| `<leader>fg` | Telescope live_grep |
| `<leader>fd` | Telescope diagnostics |
| `<leader>ds` | LSP document symbols |
| `<leader>ws` | LSP workspace symbols |
| `<leader>fz` | Telescope zoxide list |
| `<leader>fv` | Telescope help_tags |
| `<leader>fp` | Telescope builtin picker list |

Nota: `lua/custom/custom.lua` implementa "cowboy mode" — avisa si abusás de `h j k l + - e w b` sin count prefix. `lua/plugins/example.lua` está deshabilitado (`if true then return {} end`), no se carga.

## kitty (`kitty/.config/kitty/kitty.conf`)

Sin keybindings custom — usa los defaults de kitty. Solo se tocaron settings visuales (`font_size`, `cursor_shape`, `background_opacity`, etc.) y `allow_remote_control yes` (habilita el socket que usa `toggle-kitty`).

## ideavim (`ideavim/.ideavimrc`)

Leader: **`<Space>`**.

| Atajo | Acción |
|---|---|
| `<leader>w` | guardar |
| `<leader>q` | salir |
| `jk` (insert) | `<Esc>` |
| `<C-h>/<C-j>/<C-k>/<C-l>` | navegar splits |
| `<leader>sv` | split vertical |
| `<leader>sh` | split horizontal |
| `<leader>su` | quitar split |
| `<leader>ff` | Goto File |
| `<leader>fg` | Find in Path |
| `<leader>rn` | Rename Element |
| `<leader>ca` | Show Intention Actions |
| `gd` | Goto Declaration |
| `gr` | Find Usages |
| `<leader>f` | flash.search |

Plugins: `surround`, `quickscope` (mappings default propios, no listados).

## scripts (`scripts/`)

| Script | Uso |
|---|---|
| `docker-ps-visual.sh` | contenedores Docker en cajas ASCII coloreadas. `-a` incluye detenidos, `-r` modo resumen agrupado por estado. Invocado por los alias `dps`/`dpr`/`dpa`/`dpar` de fish. |
| `atajos` | menú buscable con todas las tablas de este archivo y los alias de `GIT-ALIAS.md`. En terminal abre fzf; sin terminal imprime la lista (sway la pasa a fuzzel con `$mod+F1`). |
| `calc-menu` | calculadora con resultado en vivo (rofi-calc, motor qalc): `2^10`, `20% de 150`, `5 km a millas`, `100 USD a EUR`. Enter copia el resultado al portapapeles. Bindeado a `$mod+c` en sway. |
| `cliphist` (sway) | historial del portapapeles (texto e imágenes). `$mod+p` lo abre en fuzzel; Enter vuelve a copiar la entrada elegida. |
| `toggle-kitty` | enfoca una instancia de kitty existente (vía socket `unix:/tmp/kitty-socket`) o lanza una nueva si no hay ninguna escuchando. Pensado para bindearse a un hotkey global del window manager (esa parte no vive en este repo). |
