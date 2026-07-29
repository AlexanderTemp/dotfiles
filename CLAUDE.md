# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles for attemptx, managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level directory is an independent stow package whose internal path mirrors its final location relative to `$HOME`.

**Target platform is Arch/CachyOS + sway only.** Debian/Ubuntu/Mint support was deprecated in favor of a full migration to Arch/sway — don't reintroduce apt-based instructions or Debian-specific workarounds (e.g. the `fdfind` alias) without the user asking. See `HISTORY.md` for the migration record.

```
dotfiles/
├── fish/        -> ~/.config/fish
├── nvim/        -> ~/.config/nvim
├── kitty/       -> ~/.config/kitty
├── alacritty/   -> ~/.config/alacritty
├── starship/    -> ~/.config/starship.toml
├── sway/        -> ~/.config/sway
├── waybar/      -> ~/.config/waybar
├── fuzzel/      -> ~/.config/fuzzel
├── wlogout/     -> ~/.config/wlogout
├── matugen/     -> ~/.config/matugen
├── gtklock/     -> ~/.config/gtklock
├── tmux/        -> ~/.tmux, ~/.tmux.conf
├── ideavim/     -> ~/.ideavimrc
├── environment/ -> ~/.config/environment.d
└── scripts/     -> ~/docker-ps-visual.sh, ~/.local/bin/set-wallpaper
```

`README.md`, `TODO.md`, `git-aliases.md`, `SHORTCUTS.md`, `USAGE.md`, `HISTORY.md`, and `wallpapers/` live at the repo root, outside any package, and are additionally listed in `.stow-local-ignore` as a safety net.

`install/` is a bootstrap script directory, **not** a stow package — never run `stow install`. See its own README and `HISTORY.md` for what it does and why.

## Commands

Install/update all packages:
```bash
cd ~/dotfiles
stow -R fish nvim kitty alacritty starship tmux ideavim scripts sway waybar fuzzel wlogout matugen gtklock environment
```

Install/remove a single package:
```bash
stow <package>       # install
stow -D <package>    # uninstall (removes symlinks only, repo content stays)
```

**Never run `stow .`** — it treats the whole repo as one package and produces wrong top-level symlinks (`~/fish`, `~/nvim`, `~/tmux` instead of `~/.config/fish`, `~/.config/nvim`, `~/.tmux`). Always list packages explicitly.

## Architecture notes

### sway (`sway/.config/sway/config`) and waybar (`waybar/.config/waybar/`)

- Captured from a clean Arch/CachyOS (pacman) install — see `HISTORY.md` for
  the migration record.
- The sway config references `swayidle`, `gtklock`, and `brightnessctl` for
  idle-lock and brightness keybinds — none of these were actually installed
  on the machine this config was captured from. They're covered by
  `install/install-arch.sh`, but don't assume a fresh `stow sway waybar` is
  fully functional without also running that script.
- Lock screen is `gtklock` (see the `gtklock` package below), not the plain
  `swaylock -f -c 000000` this repo used originally — invoked directly (no
  flags) from `swayidle`'s timeout/before-sleep and from `wlogout`'s `lock`
  action, both in place of the old `swaylock` calls.
- waybar's `style.css` font-family is `FantasqueSansM Nerd Font Mono`
  (`ttf-fantasque-nerd` in Arch) — kept in sync with kitty's `font_family`
  (`kitty/.config/kitty/kitty.conf`) and alacritty's `font.normal.family`
  (`FantasqueSansM Nerd Font Propo`) so the terminal and the bar render with
  the same typeface. The config was originally copied from elsewhere with
  `Iosevka Term` set instead — fixed to standardize on the font actually
  used across the rest of the repo.
- Wallpapers live in `wallpapers/` at the repo root (sibling of `assets/`,
  not nested inside the `sway` package) so they travel with the repo for
  replicability. **Keep using `output * bg` here, not a bare `exec swaybg
  ...`**: a spare `exec swaybg` line was tried so `$mod+Shift+w` could
  pkill+relaunch it directly, but sway spawns its own fallback
  (argument-less) `swaybg` on every reload whenever no `output ... bg` is
  configured — that fallback process doesn't get killed by our own pkill
  logic, so it stacked with ours on every reload (every wallpaper change,
  since matugen's post-process is `swaymsg reload`). Fix: keep `output * bg`
  in config (sway then manages its own single `swaybg` child correctly,
  replacing it cleanly on reload/live-update) and change wallpaper via
  `swaymsg output '*' bg <path> fill` at runtime instead of touching the
  `swaybg` process at all.
- The `output * bg` line itself lives in `config.d/wallpaper`, not inline in
  `sway/config` — it used to be hardcoded there to `wallpaper_2.png`, which
  meant every matugen-triggered `swaymsg reload` re-ran that stale line and
  silently reset the desktop back to it right after `set-wallpaper` had just
  set the new one (colors/waybar/borders would retheme correctly since those
  come from `config.d/colors`, but the background image itself would snap
  back to whatever was hardcoded — this is what "wallpaper picker feels
  broken, theme doesn't seem to change" turns out to mean if it comes up
  again). `config.d/wallpaper` ships a `wallpaper_2.png` fallback for a
  fresh clone, and `set-wallpaper` overwrites it with the new pick *before*
  invoking matugen, so the reload re-asserts the new wallpaper instead of
  the old one — see `scripts` below.
- `scripts/.local/bin/set-wallpaper` (run by `$mod+Shift+w`) lists every
  `.png`/`.jpg`/`.jpeg` in `wallpapers/` through a `fuzzel --dmenu` picker,
  then on selection: writes `output * bg <picked> fill` to
  `config.d/wallpaper` + `matugen image <picked> --prefer saturation`
  (retheme, triggers the reload that picks up the new `config.d/wallpaper`)
  + `swaymsg output '*' bg <picked> fill` for immediate visual feedback (see
  the `swaybg` gotcha just above — this script deliberately never calls
  `swaybg` itself). Dropping a new wallpaper file into `wallpapers/` needs no
  config change — the script just globs the directory each time it runs.
- `output *` wildcards (bg, tearing, render-time) apply regardless of monitor
  count/names. `$monitor_primary`/`$monitor_secondary` name this desktop's
  actual outputs (`HDMI-A-1`, `DVI-D-1`) to pin layout + park workspace 9 on
  the secondary — sway no-ops `output <name>`/`workspace <n> output <name>`
  for names that don't exist, so this degrades safely to single-monitor
  machines without editing anything.
- `config` is split into `config.d/{colors,keybinds,bar,wallpaper}`, included in that
  explicit order (`colors` named first, then a `config.d/*` glob) because
  `keybinds`/`bar` reference `$primary`/`$surface`/etc. and sway resolves
  `set` variables in include order — a bare glob would include them
  alphabetically and break on `bar` before `colors` is defined.
- `config.d/colors` is matugen-managed: the committed file is just a static
  bootstrap fallback (today's kanagawabones-ish hex values) so a fresh clone
  isn't broken before matugen ever runs once; `$mod+Shift+w` (in
  `config.d/keybinds`) runs `set-wallpaper` (see below), which regenerates it
  for real via `matugen image ... --prefer saturation` and also
  `swaymsg reload`s as a post-process step (see the `matugen` package
  below). Expect this file to show as locally modified after changing the
  wallpaper — that's normal, not a
  merge conflict.
- `$mod+Shift+e` opens `wlogout` (session menu: lock/logout/suspend/reboot/
  shutdown/exit-sway) instead of the old `swaynag` exit-only confirmation —
  see the `wlogout` package below.
- Imported the boxed-island waybar aesthetic + session/audio modules from
  `github.com/amatsagu/dotfiles` as a design reference (not a full copy —
  deliberately skipped its SwayFX, GTK theme, Papirus, Kvantum, cursors,
  gtklock, and backlight/power-profiles modules, none of which are part of
  this stack). Workspace numbers are plain digits (default `sway/workspaces`
  format) — the reference uses kanji numerals, deliberately not adopted here.
- Every module cluster is its own floating "island" in `style.css`
  (`#custom-launcher`, `#workspaces`, `.modules-center`, `#system`, `#clock`)
  — `#system` is the `"group/system"` module (`config.jsonc`) bundling
  `tray`+`cpu`+`memory`+`pulseaudio` into one shared bay (tray was tried as
  its own separate bay too this session; the user settled on merged).
  **Waybar CSS naming gotcha**: a module named `group/<name>` gets the CSS
  node `#<name>` — it drops the `group-` prefix entirely. `#group-system`
  (the intuitive guess) matches nothing and silently renders no background;
  confirmed by testing candidate selectors and screenshotting, not from
  docs. Colors come from `@import "../matugen/colors.css"` so the bar
  re-themes with `$mod+Shift+w`.
- `cpu`/`memory`/`pulseaudio` are plain-text `"C {usage}%"`/`"M {percentage}%"`/
  `"V {volume}%"` — icon glyphs (Nerd Font, then real FontAwesome via a
  scoped Pango `font_family` span) were tried for all three and rejected as
  looking bad/inconsistent; don't reintroduce them without the user asking.
  No `font_size='large'` markup anywhere either, for the same reason — every
  module renders at the same base 16px so nothing looks mismatched next to
  the clock/workspace numbers. `ttf-font-awesome` (`woff2-font-awesome`
  package) is still installed but no longer used by anything in this repo —
  leave it be, no need to uninstall.
- Island margins: `margin-bottom: 0` so islands sit flush with the screen
  edge instead of floating above it; the outer left/right edges
  (`#custom-launcher`, `#clock`) use `margin-left`/`margin-right: 16px` to
  match the *measured* pixel gap tiled windows get from the screen edge
  (checked via a `grim` screenshot + pixel-column scan, not derived from
  `gaps horizontal 4` — that config number and the actual rendered gap
  aren't 1:1, so measure before assuming).
- Gotcha worth remembering if icons come back for cpu/memory/pulseaudio/battery:
  `fc-scan --format '%{charset}'` reported FontAwesome7's classic "memory"
  codepoint (`f538`) as supported, but the actual glyph there is a blank
  `.notdef` box (FA7 removed/renamed the old v4 icon and left a placeholder
  instead of un-mapping the codepoint) — charset-checking a font isn't
  enough, a codepoint has to be test-rendered to confirm it's really there.
- `clock`'s format has no `%S` (no seconds) — deliberately trimmed, don't
  add it back without being asked.

### environment (`environment/.config/environment.d/path.conf`)

- Adds `~/.local/bin` to the systemd/dbus activation PATH — without it, sway's `$mod+Return exec kitty` couldn't find kitty.

### fuzzel (`fuzzel/.config/fuzzel/fuzzel.ini`)

- App launcher for sway, alternative to the `wmenu` installed by
  `install-arch.sh`. Colors are hand-picked from the kanagawabones palette
  (`kitty/.config/kitty/current-theme.conf`), not a generic Catppuccin/Tokyo
  Night theme — kept consistent with the actual kitty theme in use. Font is
  `FantasqueSansM Nerd Font Mono`, matching kitty/alacritty/waybar.
- `icons-enabled` is the correct key (not `icons` — that name doesn't exist
  in fuzzel's schema and fails `--check-config`). `icon-theme=Adwaita` since
  that's what's actually installed on the box (no Papirus).
- `selection` is transparent (`00000000`) by design: the selected entry is
  distinguished by text color only (`selection-text`/`selection-match`), not
  a solid highlight bar — a deliberate minimal look, not an oversight.

### wlogout (`wlogout/.config/wlogout/`)

- Session menu triggered by `$mod+Shift+e` (see sway above). `layout`'s `lock`
  action calls `gtklock` directly (same command `swayidle` already uses)
  rather than a separate script file, to avoid a `script/` directory for a
  one-liner.
- `style.css`'s button icons are the PNGs shipped by the `wlogout` package
  itself (`/usr/share/wlogout/icons/*.png`) — no font or icon-theme
  dependency, unlike waybar's glyphs.

### matugen (`matugen/.config/matugen/`)

- Generates a Material-You-style palette from the current wallpaper
  (`$mod+Shift+w` in sway, via `set-wallpaper` — see `scripts` below) and
  writes it to a few hand-picked templates — **not** the full template set
  from the `amatsagu/dotfiles` reference (that one also targets
  gtk-3.0/gtk-4.0/cava/steam, none of which are installed here). Only three:
  - `templates/colors.tpl` → `~/.config/matugen/colors.css` (shared
    `@define-color` vars, imported by `waybar/style.css`).
  - `templates/sway.tpl` → `~/.config/sway/config.d/colors` (see sway above).
  - `templates/fuzzel.ini` → `~/.config/fuzzel/fuzzel.ini` — **intentionally
    hand-limited** to the `match`/`selection-text`/`selection-match`/`border`
    color keys. The reference repo's fuzzel template overwrites the whole
    file (Noto Sans, `terminal=foot`, `icon-theme=Papirus-Dark`,
    `dpi-aware=yes`); applying that verbatim here would silently undo the
    `dpi-aware=no` fix for this box's low-DPI panel and the kitty/
    FantasqueSansM/`width=64` tuning done earlier. `selection` itself stays
    `00000000` (transparent) always — matugen never touches it — per the
    deliberate no-solid-highlight look documented under fuzzel above.
- `[templates.sway]` carries `post_hook = "swaymsg reload"` — sway/waybar
  colors only take effect after a reload, matugen just writes the file
  otherwise. This used to be a top-level `[[config.post_process]]` block
  with a `command`/`only_on_change` schema; that schema doesn't exist in
  matugen 4.1.0 (per-template `post_hook` is the real field, confirmed via
  `strings` on the binary since `--help` doesn't document the config file
  format) so it was silently ignored — templates still wrote correctly, but
  nothing ever reloaded sway automatically, making the retheme look like it
  "only updates on manual reload" (`$mod+Shift+c`). Don't reintroduce the
  `config.post_process` form.
- `matugen image <path>` needs `--prefer saturation` on this wallpaper (or
  any image with more than one plausible dominant color) — without it,
  matugen errors out asking which candidate color to prefer instead of
  guessing.
- Not a daemon: it's a one-shot CLI run from the keybind, so it costs nothing
  at idle.

### gtklock (`gtklock/.config/gtklock/`)

- Lock screen, replacing plain `swaylock -f -c 000000` (see sway/wlogout
  above). `style.css` `@import`s `../matugen/colors.css` directly (same
  pattern as waybar) — no dedicated matugen template needed, so it wasn't
  added to `matugen/config.toml`.
- `style.css`'s `background-image` points at
  `../../dotfiles/wallpapers/wallpaper_2.png` (relative from
  `~/.config/gtklock/`) — a **static** wallpaper, it does not follow whatever
  `set-wallpaper` last picked. `sway/config.d/wallpaper` (see sway above) is
  a state file of exactly this kind now, but nothing wires gtklock's CSS to
  it — a GTK CSS `url()` can't read a shell variable, so following it would
  need a matugen template for this file too, deliberately not added.
- No `gtklock-userinfo-module`/`-playerctl-module`/`-powerbar-module` —
  none installed, `config.ini` has no `modules=` line. Also no
  `gtk-theme=Fluent-grey-Dark` (that GTK theme isn't installed either);
  left at GTK default.

### scripts (`scripts/`)

- `docker-ps-visual.sh` → `~/docker-ps-visual.sh` (unrelated to the rest of
  this section).
- `.local/bin/set-wallpaper` → `~/.local/bin/set-wallpaper` (on `PATH` via
  the `environment` package). Run by `$mod+Shift+w` — see sway/waybar notes
  above for what it does, the `swaybg`-vs-`output * bg` gotcha, and why it
  writes `config.d/wallpaper` before calling matugen. That file doubles as
  login-persistence (sway reads `config.d/*` on every start, not just
  reload), so the last pick survives a reboot without a separate marker
  file like the `amatsagu/dotfiles` reference's `.current-wallpaper`.

### tmux (`tmux/.tmux.conf`, `tmux/.tmux/`)

- Prefix is `Ctrl-a` (not the default `Ctrl-b`).
- Plugins are vendored directly inside `tmux/.tmux/plugins/` and committed to git — **not** managed by TPM auto-download. TPM (`tpm`) is still used only to source the plugins already present on disk (`run '~/.tmux/plugins/tpm/tpm'` at the bottom of the conf).
- Session persistence uses `tmux-resurrect` only. `tmux-continuum` and `tmuxifier` were deliberately removed (see below) — there is no background auto-save.
  - `prefix Ctrl-s` / `prefix Ctrl-r`: save/restore the resurrect "last" snapshot (unnamed, default resurrect behavior).
  - `prefix S` / `prefix L`: save/load a **named** layout, via the custom scripts `tmux/.tmux/scripts/save-named.sh` and `load-named.sh`. Named snapshots live in `~/.tmux/resurrect/named/<name>.txt` (local machine state, not committed to the repo). `load-named.sh` opens an fzf popup to pick which one to restore.
  - `@resurrect-dir` is pinned to `~/.tmux/resurrect` explicitly in the conf.
- `tmuxifier` (project/layout manager) was fully removed from this repo — no package, no fish aliases, no PATH entry. Do not reintroduce it without the user asking; the named-resurrect-save workflow above replaces its use case.

### fish (`fish/.config/fish/`)

- `config.fish` holds interactive aliases/functions (git shortcuts, eza-based `ls` replacements, tmux helpers) and sets `fish_user_paths` (universal variable — editing this list in `config.fish` does not retroactively remove stale entries already baked into the user's live `fish_variables`; that file is gitignored local state).
- `tmuxifier`-related aliases (`muxi`, `muxi-load`, `muxi-new`) and its `PATH` entry were removed along with the tmuxifier package.

### Git aliases

The user's `~/.gitconfig` `[alias]` block is mirrored for reference/backup in `git-aliases.md` at the repo root. This file is documentation only — it is not read by any tool and is explicitly stow-ignored. Update it manually if `~/.gitconfig` aliases change.

### `.gitignore` vs `.stow-local-ignore`

Both exist and serve different purposes: `.gitignore` keeps local/runtime state (fish history, caches, editor state) out of git; `.stow-local-ignore` keeps specific files inside package directories from being symlinked by stow. Package-internal ignores (e.g. VCS cruft) are handled by the default patterns already present; root-level docs are ignored explicitly by name.
