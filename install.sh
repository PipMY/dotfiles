#!/usr/bin/env bash
# Install this snapshot into $HOME, backing up overwritten paths first.
set -euo pipefail

repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
backup="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
changed=0

while IFS= read -r entry; do
  [[ -z "$entry" || "$entry" == \#* ]] && continue
  rel=${entry%/}
  src="$repo/$rel"
  dst="$HOME/$rel"
  [[ -e "$src" || -L "$src" ]] || continue

  if [[ -e "$dst" || -L "$dst" ]]; then
    mkdir -p "$backup/$(dirname -- "$rel")"
    cp -a -- "$dst" "$backup/$rel"
  fi

  mkdir -p "$(dirname -- "$dst")"
  if [[ -d "$src" && ! -L "$src" ]]; then
    mkdir -p "$dst"
    rsync -a "$src/" "$dst/"
  else
    cp -a -- "$src" "$dst"
  fi
  changed=1
done < "$repo/manifest.txt"

if (( changed )); then
  printf 'Installed dotfiles. Previous paths were backed up under %s\n' "$backup"
fi
