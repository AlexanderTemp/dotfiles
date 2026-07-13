# Shortcuts

Referencia de todos los atajos de teclado, alias y funciones configurados en este repo de dotfiles. Documentación únicamente — no se lee por ningún tool ni se symlinkea (ver `.stow-local-ignore`). Actualizar manualmente si cambian los configs.

## fish (`fish/.config/fish/config.fish`)

| Comando | Equivale a | Descripción |
|---|---|---|
| `g` | `git` | atajo corto |
| `ga` | `git add .` | stage todo |
| `d` | `docker` | atajo corto |
| `x` | `exit` | salir de la shell |
| `ii` | `npm install` | |
| `dev` | `npm run dev` | |
| `v`, `nv` | `nvim` | abrir editor |
| `rgf` | `rg --files \| rg` | filtrar listado de archivos con ripgrep |
| `fd` | `fdfind` | binario de `fd` en Debian/Ubuntu se llama `fdfind` |
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

## tmux (`tmux/.tmux.conf`)

Prefix: **`Ctrl-a`** (el default `Ctrl-b` está deshabilitado).

| Atajo | Acción |
|---|---|
| `prefix r` | recargar config (con mensaje de confirmación) |
| `prefix Ctrl-n` | pedir nombre y crear nueva sesión |
| `prefix Ctrl-j` | popup fzf con lista de sesiones, cambiar a la elegida |
| `prefix s` | split horizontal |
| `prefix x` | split vertical |
| `prefix h/j/k/l` | navegar entre panes (estilo vim) |
| `prefix Ctrl-s` | tmux-resurrect: guardar snapshot "last" |
| `prefix Ctrl-r` | tmux-resurrect: restaurar snapshot "last" |
| `prefix S` | guardar layout **con nombre** (`save-named.sh`) → `~/.tmux/resurrect/named/<nombre>.txt` |
| `prefix L` | popup fzf para cargar un layout con nombre (`load-named.sh`) |

Plugins vendorizados en `tmux/.tmux/plugins/`: `tpm`, `tmux-sensible`, `vim-tmux-navigator`, `rose-pine`, `tmux-resurrect`.

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

Nota: `lua/custom/custom.lua` implementa "cowboy mode" — avisa si abusás de `h j k l + - e w b` sin count prefix. `lua/plugins/example.lua` está deshabilitado (`if true then return {} end`), no se carga. `lua/plugins/md-prev.lua` tiene rutas CSS hardcodeadas de otra máquina (`/Users/michaelwilliams/...`), probablemente rota.

## kitty (`kitty/.config/kitty/kitty.conf`)

Sin keybindings custom — usa los defaults de kitty. Solo se tocaron settings visuales (`font_size`, `cursor_shape`, `background_opacity`, etc.) y `allow_remote_control yes` (habilita el socket que usa `toggle-kitty`).

## alacritty (`alacritty/.config/alacritty/alacritty.toml`)

Sin keybindings de teclado custom. Solo mouse:

| Botón | Acción |
|---|---|
| `Forward` | `ScrollPageUp` |
| `Back` | `ScrollPageDown` |

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
| `toggle-kitty` | enfoca una instancia de kitty existente (vía socket `unix:/tmp/kitty-socket`) o lanza una nueva si no hay ninguna escuchando. Pensado para bindearse a un hotkey global del window manager (esa parte no vive en este repo). |
