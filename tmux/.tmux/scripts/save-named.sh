#!/usr/bin/env bash
# Guarda la sesión/estructura de paneles actual bajo un nombre, usando tmux-resurrect.
set -euo pipefail

name="$1"
resurrect_dir="$HOME/.tmux/resurrect"
named_dir="$resurrect_dir/named"

mkdir -p "$named_dir"
"$HOME/.tmux/plugins/tmux-resurrect/scripts/save.sh" quiet
cp -L "$resurrect_dir/last" "$named_dir/${name}.txt"

tmux display-message "Layout '${name}' guardado"
