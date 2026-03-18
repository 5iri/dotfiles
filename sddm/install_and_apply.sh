#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/sddm-theme-sources"
THEMES_DIR="/usr/share/sddm/themes"
CONF_DIR="/etc/sddm.conf.d"

usage() {
  cat <<'EOF'
Usage:
  ./install_and_apply.sh --install <theme|all>
  ./install_and_apply.sh --apply <theme>

Themes:
  silent | astronaut | yorha | xdm

Examples:
  ./install_and_apply.sh --install all
  ./install_and_apply.sh --apply astronaut
EOF
}

require_cmd() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Missing required command: $cmd" >&2
    exit 1
  fi
}

theme_url() {
  case "$1" in
    silent) echo "https://github.com/uiriansan/SilentSDDM.git" ;;
    astronaut) echo "https://github.com/Keyitdev/sddm-astronaut-theme.git" ;;
    yorha) echo "https://github.com/NeekoKun/YoRHa-sddm-theme.git" ;;
    xdm) echo "https://github.com/Zebreus/sddm-xdm-theme.git" ;;
    *) return 1 ;;
  esac
}

theme_dirname() {
  case "$1" in
    silent) echo "silent" ;;
    astronaut) echo "sddm-astronaut-theme" ;;
    yorha) echo "YoRHa-sddm-theme" ;;
    xdm) echo "sddm-xdm-theme" ;;
    *) return 1 ;;
  esac
}

install_one_theme() {
  local theme="$1"
  local url dest clone_dir src
  url="$(theme_url "$theme")"
  dest="$(theme_dirname "$theme")"
  clone_dir="$WORK_DIR/$theme"

  echo "Installing theme: $theme ($url)"
  rm -rf "$clone_dir"
  git clone --depth 1 "$url" "$clone_dir"

  if [[ -d "$clone_dir/$dest" ]]; then
    src="$clone_dir/$dest"
  else
    src="$clone_dir"
  fi

  sudo install -d "$THEMES_DIR/$dest"
  sudo cp -a "$src/." "$THEMES_DIR/$dest/"

  if [[ -d "$clone_dir/Fonts" ]]; then
    sudo cp -a "$clone_dir/Fonts/." /usr/share/fonts/
  fi
  if [[ -d "$clone_dir/fonts" ]]; then
    sudo cp -a "$clone_dir/fonts/." /usr/share/fonts/
  fi
}

apply_theme() {
  local theme="$1"
  local conf="$SCRIPT_DIR/conf.d/theme-$theme.conf"
  if [[ ! -f "$conf" ]]; then
    echo "Config snippet not found: $conf" >&2
    exit 1
  fi

  echo "Applying SDDM theme config: $theme"
  sudo install -d "$CONF_DIR"
  sudo cp "$conf" "$CONF_DIR/90-theme-custom.conf"

  if [[ "$theme" == "silent" || "$theme" == "astronaut" ]]; then
    sudo cp "$SCRIPT_DIR/conf.d/virtualkbd.conf" "$CONF_DIR/91-virtualkbd.conf"
  else
    sudo rm -f "$CONF_DIR/91-virtualkbd.conf"
  fi

  echo
  echo "Applied. To validate quickly:"
  echo "  sddm-greeter --test-mode --theme $THEMES_DIR/$(theme_dirname "$theme")"
  echo "Then restart SDDM (from TTY):"
  echo "  sudo systemctl restart sddm"
}

main() {
  require_cmd git
  require_cmd sudo

  if [[ $# -ne 2 ]]; then
    usage
    exit 1
  fi

  local action="$1"
  local target="$2"

  case "$action" in
    --install)
      mkdir -p "$WORK_DIR"
      if [[ "$target" == "all" ]]; then
        install_one_theme silent
        install_one_theme astronaut
        install_one_theme yorha
        install_one_theme xdm
        sudo fc-cache -f >/dev/null 2>&1 || true
      else
        theme_url "$target" >/dev/null
        install_one_theme "$target"
        sudo fc-cache -f >/dev/null 2>&1 || true
      fi
      ;;
    --apply)
      theme_url "$target" >/dev/null
      apply_theme "$target"
      ;;
    *)
      usage
      exit 1
      ;;
  esac
}

main "$@"
