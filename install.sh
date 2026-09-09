#!/usr/bin/env bash
set -euo pipefail

MAIN_ID="radyalz.bar-control"
LAUNCHER_ID="radyalz.bar-control-launcher"
OLD_MAIN_ID="radyalz.animated-autohide-bar"
OLD_LAUNCHER_ID="radyalz.animated-autohide-launcher"

plugin="$HOME/.config/omarchy/plugins/$MAIN_ID"
launcher_plugin="$HOME/.config/omarchy/plugins/$LAUNCHER_ID"
old_plugin="$HOME/.config/omarchy/plugins/$OLD_MAIN_ID"
old_launcher_plugin="$HOME/.config/omarchy/plugins/$OLD_LAUNCHER_ID"
stock_bar="/usr/share/omarchy/shell/plugins/bar"
here="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
stamp="$(date +%Y%m%d-%H%M%S)"
state_dir="$HOME/.local/state/radyalz-bar-control"
settings_file="$HOME/.config/omarchy/radyalz-bar-control.json"
backup="$state_dir/backups/$stamp"
legacy_backup="$state_dir/legacy-$stamp"
mode=""

usage() {
  cat <<'USAGE'
Usage: ./install.sh [--launcher left|center|right|app]

Radyalz Bar Control v0.2.3 can install fresh from the current Omarchy stock bar
runtime. If an older Animated Autohide Bar install is present, its settings are
migrated before the old plugin IDs are retired.

The installer always creates a Linux application launcher as a recovery path.
The --launcher option controls whether a settings button is also placed in the bar.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --launcher)
      [[ $# -ge 2 ]] || { printf 'Missing value for --launcher.\n' >&2; exit 2; }
      mode="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

case "$mode" in
  "") ;;
  left|center|right|app) ;;
  *) printf 'Invalid launcher mode: %s\n' "$mode" >&2; exit 2 ;;
esac

if [[ -z "$mode" ]]; then
  if [[ -t 0 ]]; then
    printf '\nRadyalz Bar Control — settings access\n'
    printf 'The Linux app launcher is always installed as a fallback.\n\n'
    printf 'Where should the optional bar settings button go?\n'
    printf '  1) Left\n'
    printf '  2) Center\n'
    printf '  3) Right\n'
    printf '  4) No bar button — app launcher only\n\n'
    while :; do
      read -r -p 'Choose [1-4]: ' choice
      case "$choice" in
        1) mode="left"; break ;;
        2) mode="center"; break ;;
        3) mode="right"; break ;;
        4) mode="app"; break ;;
        *) printf 'Please choose 1, 2, 3, or 4.\n' ;;
      esac
    done
  else
    mode="app"
  fi
fi

mkdir -p "$plugin" "$state_dir/backups"

# Keep a safety backup of any existing install before changing runtime files.
if [[ -d "$plugin" ]] && find "$plugin" -mindepth 1 -maxdepth 1 -print -quit | grep -q .; then
  mkdir -p "$backup"
  cp -a "$plugin/." "$backup/"
fi
if [[ -f "$settings_file" ]]; then
  mkdir -p "$backup"
  cp -a "$settings_file" "$backup/radyalz-bar-control.json"
fi

# Seed the runtime. Prefer the previous working plugin when it exists so local
# user state can migrate cleanly; otherwise use the stock Omarchy bar runtime.
if [[ -d "$old_plugin" ]]; then
  printf 'Migrating runtime files from %s ...\n' "$OLD_MAIN_ID"
  cp -a "$old_plugin/." "$plugin/"
elif [[ ! -f "$plugin/BarModel.js" ]]; then
  if [[ ! -d "$stock_bar" ]]; then
    printf 'Stock Omarchy bar runtime was not found at %s\n' "$stock_bar" >&2
    exit 1
  fi
  printf 'Seeding runtime from the current Omarchy stock bar ...\n'
  cp -a "$stock_bar/." "$plugin/"
fi

# Keep user settings outside the plugin runtime so an Omarchy/plugin update can
# replace the installed plugin directory without deleting the user's choices.
# Migrate the previous plugin-local settings file the first time this layout is
# installed, preferring the old plugin id when both legacy copies exist.
if [[ ! -f "$settings_file" ]]; then
  for candidate in "$plugin/settings.json" "$old_plugin/settings.json"; do
    if [[ -f "$candidate" ]]; then
      cp -a "$candidate" "$settings_file"
      printf 'Migrated settings to %s\n' "$settings_file"
      break
    fi
  done
fi

# A plugin-local settings.json is legacy state now. Leaving it behind is
# misleading because Service.qml and Bar.qml no longer read it.
rm -f "$plugin/settings.json"

# Overlay project-owned files and the modular settings UI.
for file in Bar.qml Service.qml SettingsPanel.qml manifest.json; do
  cp -a "$here/$file" "$plugin/$file"
done
rm -rf "$plugin/components" "$plugin/pages"
cp -a "$here/components" "$plugin/components"
cp -a "$here/pages" "$plugin/pages"

if [[ ! -f "$plugin/BarModel.js" ]]; then
  printf 'Missing required runtime asset: %s\n' "$plugin/BarModel.js" >&2
  exit 1
fi

# Install optional companion launcher plugin.
mkdir -p "$launcher_plugin"
cp -a "$here/launcher/manifest.json" "$launcher_plugin/manifest.json"
cp -a "$here/launcher/BarWidget.qml" "$launcher_plugin/BarWidget.qml"

# Always install a desktop/app-menu launcher so the GUI remains reachable even
# if the bar button is removed or the bar itself is hidden.
mkdir -p "$HOME/.local/bin" "$HOME/.local/share/applications"
install -m 0755 "$here/radyalz-bar-control-settings" "$HOME/.local/bin/radyalz-bar-control-settings"
cat > "$HOME/.local/share/applications/radyalz-bar-control.desktop" <<DESKTOP
[Desktop Entry]
Type=Application
Name=Radyalz Bar Control
Comment=Configure Radyalz Bar Control
Exec=$HOME/.local/bin/radyalz-bar-control-settings
Icon=preferences-system
Terminal=false
Categories=Settings;Utility;
StartupNotify=false
DESKTOP

# Remove legacy application-launcher files from v0.2.2.
rm -f "$HOME/.local/bin/animated-autohide-settings"
rm -f "$HOME/.local/share/applications/animated-autohide-bar.desktop"

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "$HOME/.local/share/applications" >/dev/null 2>&1 || true
fi

# Ask the shell to discover the new manifests before enabling them.
if command -v omarchy-shell >/dev/null 2>&1; then
  omarchy-shell shell rescanPlugins >/dev/null 2>&1 || true
fi

if command -v omarchy >/dev/null 2>&1; then
  # Retire old companion widget first so it cannot remain in a bar section.
  omarchy plugin disable "$OLD_LAUNCHER_ID" --yes >/dev/null 2>&1 \
    || omarchy plugin disable "$OLD_LAUNCHER_ID" >/dev/null 2>&1 \
    || true

  # Enabling a full bar replaces the currently active full bar.
  omarchy plugin enable "$MAIN_ID" --yes >/dev/null 2>&1 \
    || omarchy plugin enable "$MAIN_ID" >/dev/null 2>&1 \
    || true

  omarchy plugin disable "$LAUNCHER_ID" --yes >/dev/null 2>&1 \
    || omarchy plugin disable "$LAUNCHER_ID" >/dev/null 2>&1 \
    || true

  if [[ "$mode" != "app" ]]; then
    omarchy plugin enable "$LAUNCHER_ID" --section "$mode" --yes >/dev/null 2>&1 \
      || omarchy plugin enable "$LAUNCHER_ID" --section "$mode" >/dev/null 2>&1 \
      || true
  fi
fi

# Make shell.json deterministic even if the Omarchy helper command changes or
# fails. The bar id activates this bar; the plugins entry starts its service.
MODE="$mode" python - <<'PY'
import json
import os
from pathlib import Path

main_id = 'radyalz.bar-control'
launcher_id = 'radyalz.bar-control-launcher'
old_ids = {
    'radyalz.animated-autohide-bar',
    'radyalz.animated-autohide-launcher',
}
mode = os.environ['MODE']

p = Path.home() / '.config/omarchy/shell.json'
if p.exists():
    data = json.loads(p.read_text())
    bar = data.setdefault('bar', {})
    bar['id'] = main_id

    layout = bar.setdefault('layout', {})
    for section in ('left', 'center', 'right'):
        cleaned = [
            entry for entry in layout.get(section, [])
            if not (
                isinstance(entry, dict)
                and entry.get('id') in old_ids | {launcher_id}
            )
        ]
        if mode == section:
            cleaned.append({'id': launcher_id})
        layout[section] = cleaned

    plugins = []
    seen = set()
    for entry in data.get('plugins', []):
        if not isinstance(entry, dict):
            continue
        pid = entry.get('id')
        if pid in old_ids or pid == main_id:
            continue
        key = json.dumps(entry, sort_keys=True)
        if key not in seen:
            plugins.append(entry)
            seen.add(key)
    plugins.append({'id': main_id})

    data['plugins'] = plugins
    data['version'] = 1
    p.write_text(json.dumps(data, indent=2) + '\n')
PY

# Move legacy plugin directories out of the live plugin registry instead of
# deleting them outright. This is the uninstall of the old IDs and a recovery
# copy at the same time.
if [[ -d "$old_plugin" || -d "$old_launcher_plugin" ]]; then
  mkdir -p "$legacy_backup"
  [[ ! -d "$old_plugin" ]] || mv "$old_plugin" "$legacy_backup/$OLD_MAIN_ID"
  [[ ! -d "$old_launcher_plugin" ]] || mv "$old_launcher_plugin" "$legacy_backup/$OLD_LAUNCHER_ID"
  printf 'Legacy backup: %s\n' "$legacy_backup"
fi

if command -v omarchy-shell >/dev/null 2>&1; then
  omarchy-shell shell rescanPlugins >/dev/null 2>&1 || true
fi
if command -v omarchy >/dev/null 2>&1; then
  omarchy restart shell
else
  printf 'Restart the Omarchy shell to load the plugin.\n'
fi

printf '\nInstalled Radyalz Bar Control v0.2.3.\n'
printf 'Plugin ID: %s\n' "$MAIN_ID"
printf 'Linux app launcher: Radyalz Bar Control\n'
if [[ "$mode" == "app" ]]; then
  printf 'Bar settings button: not placed in the bar\n'
else
  printf 'Bar settings button: %s section\n' "$mode"
fi

# Open settings once after installation. Failure is harmless; the desktop
# launcher remains available from the application menu.
if command -v omarchy-shell >/dev/null 2>&1; then
  sleep 1
  omarchy-shell shell summon "$MAIN_ID" '{}' >/dev/null 2>&1 || true
fi
