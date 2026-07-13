# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles for attemptx, managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level directory is an independent stow package whose internal path mirrors its final location relative to `$HOME`.

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

`README.md`, `TODO.md`, and `git-aliases.md` live at the repo root, outside any package, and are additionally listed in `.stow-local-ignore` as a safety net.

## Commands

Install/update all packages:
```bash
cd ~/dotfiles
stow -R fish nvim kitty alacritty starship tmux ideavim scripts
```

Install/remove a single package:
```bash
stow <package>       # install
stow -D <package>    # uninstall (removes symlinks only, repo content stays)
```

**Never run `stow .`** — it treats the whole repo as one package and produces wrong top-level symlinks (`~/fish`, `~/nvim`, `~/tmux` instead of `~/.config/fish`, `~/.config/nvim`, `~/.tmux`). Always list packages explicitly.

## Architecture notes

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
