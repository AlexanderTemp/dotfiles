#!/usr/bin/env bash
# Muestra un selector fzf con los layouts guardados y restaura el elegido con tmux-resurrect.
set -euo pipefail

resurrect_dir="$HOME/.tmux/resurrect"
named_dir="$resurrect_dir/named"

mkdir -p "$named_dir"

name="$(ls "$named_dir" 2>/dev/null | sed 's/\.txt$//' | fzf --reverse --prompt='Cargar layout> ')"
[ -z "${name:-}" ] && exit 0

ln -sf "$named_dir/${name}.txt" "$resurrect_dir/last"
"$HOME/.tmux/plugins/tmux-resurrect/scripts/restore.sh"
