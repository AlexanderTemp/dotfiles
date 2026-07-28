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
├── tmux/        -> ~/.tmux, ~/.tmux.conf
├── ideavim/     -> ~/.ideavimrc
└── scripts/     -> ~/docker-ps-visual.sh, ~/toggle-kitty
```

`README.md`, `TODO.md`, `git-aliases.md`, `HISTORY.md`, and `wallpapers/` live at the repo root, outside any package, and are additionally listed in `.stow-local-ignore` as a safety net.

`install/` is a bootstrap script directory, **not** a stow package — never run `stow install`. See its own README and `HISTORY.md` for what it does and why.

## Commands

Install/update all packages:
```bash
cd ~/dotfiles
stow -R fish nvim kitty alacritty starship tmux ideavim scripts sway waybar
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
- The sway config references `swayidle`, `swaylock`, and `brightnessctl` for
  idle-lock and brightness keybinds — none of these were actually installed
  on the machine this config was captured from. They're covered by
  `install/install-arch.sh`, but don't assume a fresh `stow sway waybar` is
  fully functional without also running that script.
- waybar's `style.css` font-family is `FantasqueSansM Nerd Font Mono`
  (`ttf-fantasque-nerd` in Arch) — kept in sync with kitty's `font_family`
  (`kitty/.config/kitty/kitty.conf`) and alacritty's `font.normal.family`
  (`FantasqueSansM Nerd Font Propo`) so the terminal and the bar render with
  the same typeface. The config was originally copied from elsewhere with
  `Iosevka Term` set instead — fixed to standardize on the font actually
  used across the rest of the repo.
- Wallpapers live in `wallpapers/` at the repo root (sibling of `assets/`,
  not nested inside the `sway` package) so they travel with the repo for
  replicability. The sway config's `output * bg` points at
  `~/dotfiles/wallpapers/wallpaper_2.png` — a hardcoded path into the repo
  clone location, not through the stowed `~/.config/sway` symlink. This
  assumes the repo is cloned to `~/dotfiles`.
- Machine-specific bit that won't travel to another box as-is: the output
  name is hardcoded (`output DP-1 mode 1920x1080@60Hz`).

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
