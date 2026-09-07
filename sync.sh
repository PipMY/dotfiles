#!/usr/bin/env bash
# Refresh this repository from the current home-directory configuration.
set -euo pipefail

repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

while IFS= read -r entry; do
  [[ -z "$entry" || "$entry" == \#* ]] && continue
  rel=${entry%/}
  src="$HOME/$rel"
  dst="$repo/$rel"

  if [[ ! -e "$src" && ! -L "$src" ]]; then
    printf 'Missing, skipped: %s\n' "$rel" >&2
    continue
  fi

  mkdir -p "$(dirname -- "$dst")"
  if [[ -d "$src" && ! -L "$src" ]]; then
    mkdir -p "$dst"
    rsync -a --delete "$src/" "$dst/"
  else
    cp -a -- "$src" "$dst"
  fi
done < "$repo/manifest.txt"

# Generated machine state and personal identity intentionally stay out of version control.
rm -rf -- \
  "$repo/.gitconfig" \
  "$repo/.config/fish/fish_variables" \
  "$repo/.config/gtk-4.0/thumbnail.png" \
  "$repo/.config/ksmserverrc" \
  "$repo/.config/phototonic"

# Normalize local home paths and remove machine/account-specific entries.
REPO="$repo" python3 <<'PY'
import os
from pathlib import Path

repo = Path(os.environ["REPO"])
home = str(Path.home())
for relative in (
    ".bash_profile",
    ".bashrc",
    ".zshrc",
    ".config/fish/config.fish",
    ".config/psd/.psd.conf",
):
    path = repo / relative
    sanitized = path.read_text().replace(home, "$HOME")
    mode = path.stat().st_mode
    temporary = path.with_name(path.name + ".sanitizing")
    temporary.write_text(sanitized)
    temporary.chmod(mode)
    temporary.replace(path)
PY
sed -i \
  -e '/^alias hammy=/d' \
  "$repo/.zshrc"
sed -i \
  -e '/^Image=file:\/\/\/home\//d' \
  -e '/^PreviewImage=file:\/\/\/home\//d' \
  "$repo/.config/kscreenlockerrc" \
  "$repo/.config/plasma-org.kde.plasma.desktop-appletsrc"

printf '\nRepository status:\n'
git -C "$repo" status --short
