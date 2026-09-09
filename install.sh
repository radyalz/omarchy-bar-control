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
here="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
stamp="$(date +%Y%m%d-%H%M%S)"
state_dir="$HOME/.local/state/radyalz-bar-control"
backup="$state_dir/backups/$stamp"
legacy_backup="$state_dir/legacy-$stamp"
mode=""

usage() {
  cat <<'USAGE'
Usage: ./install.sh [--launcher left|center|right|app]

Radyalz Bar Control v0.2.3 migrates the previous Animated Autohide Bar install
when it is present, then retires the old plugin IDs.

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

mkdir -p "$plugin" "$plugin/components" "$state_dir/backups"

# Keep a safety backup of any existing v0.2.3+ install.
if [[ -d "$plugin" ]] && find "$plugin" -mindepth 1 -maxdepth 1 -print -quit | grep -q .; then
  mkdir -p "$backup"
  cp -a "$plugin/." "$backup/"
fi

# v0.2.3 is a rename of the working v0.2.2 project. The previous install
# contains the inherited Islands Bar runtime files (BarModel.js, widgets,
# indicators, etc.) that the small GUI upgrade archive did not duplicate.
# Migrate those files before retiring the old ID.
if [[ -d "$old_plugin" ]]; then
  printf 'Migrating runtime files from %s ...\n' "$OLD_MAIN_ID"
  cp -a "$old_plugin/." "$plugin/"
fi

# Preserve the old user's settings under the new plugin path.
if [[ -f "$old_plugin/settings.json" && ! -f "$plugin/settings.json" ]]; then
  cp -a "$old_plugin/settings.json" "$plugin/settings.json"
fi

# Overlay the v0.2.3 files.
for file in Bar.qml Service.qml SettingsPanel.qml manifest.json; do
  cp -a "$here/$file" "$plugin/$file"
done
mkdir -p "$plugin/components"
cp -a "$here/components/CurveEditor.qml" "$plugin/components/CurveEditor.qml"

# Refuse to destroy the working old install if the inherited runtime is absent.
missing=0
for required in BarModel.js widgets; do
  if [[ ! -e "$plugin/$required" ]]; then
    printf 'Missing required runtime asset: %s\n' "$plugin/$required" >&2
    missing=1
  fi
done
if [[ "$missing" -ne 0 ]]; then
  printf '\nInstallation stopped safely. Keep the old plugin installed and run this installer again.\n' >&2
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

# Clean stale legacy IDs from shell.json and ensure the renamed bar is selected.
python - <<'PY'
import json
from pathlib import Path
p = Path.home() / '.config/omarchy/shell.json'
if p.exists():
    data = json.loads(p.read_text())
    bar = data.setdefault('bar', {})
    if bar.get('id') in (None, '', 'radyalz.animated-autohide-bar'):
        bar['id'] = 'radyalz.bar-control'
    plugins = []
    seen = set()
    for entry in data.get('plugins', []):
        if not isinstance(entry, dict):
            continue
        pid = entry.get('id')
        if pid in {'radyalz.animated-autohide-bar', 'radyalz.animated-autohide-launcher'}:
            continue
        key = json.dumps(entry, sort_keys=True)
        if key not in seen:
            plugins.append(entry)
            seen.add(key)
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
