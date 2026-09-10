#!/usr/bin/env bash
# Sync machine-specific KDE configs between the dotfiles repo and ~/.config.
#
# These files (kcminputrc, kwinrc, plasma-org.kde.plasma.desktop-appletsrc)
# are COPIED instead of symlinked: Plasma rewrites them constantly at runtime,
# and a symlink would funnel all that churn straight into the repo.
#
# Usage:
#   kde_machine_sync.sh apply  [machine]   # repo -> ~/.config (run by ./install kde <machine>)
#   kde_machine_sync.sh export [machine]   # ~/.config -> repo, then review with git diff
#   kde_machine_sync.sh diff   [machine]   # show what export would bring into the repo
#
# [machine] defaults to zenbook-duo.

set -euo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
REPO_DIR="$(cd "$(dirname "$SCRIPT_PATH")/.." && pwd)"
MACHINE="${2:-zenbook-duo}"
MACHINE_DIR="$REPO_DIR/kde/machines/$MACHINE/config"
TARGET_DIR="$HOME/.config"

if [[ ! -d "$MACHINE_DIR" ]]; then
  echo "error: no such machine folder: $MACHINE_DIR" >&2
  exit 1
fi

same_file() { [[ "$(readlink -f "$1")" == "$(readlink -f "$2")" ]]; }

case "${1:-}" in
  apply)
    for f in "$MACHINE_DIR"/*; do
      [[ -f "$f" ]] || continue
      base="$(basename "$f")"
      # --remove-destination replaces any stale symlink left over from the
      # old symlink-everything setup with a real file copy
      cp -f --remove-destination "$f" "$TARGET_DIR/$base"
      echo "applied  $base -> $TARGET_DIR/$base"
    done
    ;;
  export)
    for f in "$MACHINE_DIR"/*; do
      [[ -f "$f" ]] || continue
      base="$(basename "$f")"
      live="$TARGET_DIR/$base"
      if [[ ! -f "$live" ]]; then
        echo "skipped  $base (not found in $TARGET_DIR)" >&2
        continue
      fi
      if same_file "$live" "$f"; then
        echo "skipped  $base (still symlinked into the repo -- run 'apply' first)" >&2
        continue
      fi
      cp -f "$live" "$f"
      echo "exported $live -> kde/machines/$MACHINE/config/$base"
    done
    echo
    echo "Review with: git -C \"$REPO_DIR\" diff kde/machines/$MACHINE"
    ;;
  diff)
    for f in "$MACHINE_DIR"/*; do
      [[ -f "$f" ]] || continue
      base="$(basename "$f")"
      if [[ -f "$TARGET_DIR/$base" ]]; then
        diff -u "$f" "$TARGET_DIR/$base" || true
      else
        echo "missing in $TARGET_DIR: $base" >&2
      fi
    done
    ;;
  *)
    echo "usage: $(basename "$0") {apply|export|diff} [machine]" >&2
    exit 1
    ;;
esac
