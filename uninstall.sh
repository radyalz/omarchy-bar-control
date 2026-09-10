#!/usr/bin/env bash
set -euo pipefail

MAIN_ID="radyalz.bar-control"
# Retired second-plugin id from 0.4.2 and earlier; cleaned up here too.
SPLIT_LAUNCHER_ID="radyalz.bar-control-launcher"
plugin="$HOME/.config/omarchy/plugins/$MAIN_ID"
split_launcher_plugin="$HOME/.config/omarchy/plugins/$SPLIT_LAUNCHER_ID"

if command -v omarchy >/dev/null 2>&1; then
  omarchy plugin disable "$SPLIT_LAUNCHER_ID" --yes >/dev/null 2>&1 \
    || omarchy plugin disable "$SPLIT_LAUNCHER_ID" >/dev/null 2>&1 \
    || true
fi

python - <<'PY'
import json
from pathlib import Path

ids = {'radyalz.bar-control', 'radyalz.bar-control-launcher'}
p = Path.home() / '.config/omarchy/shell.json'
if p.exists():
    data = json.loads(p.read_text())
    bar = data.get('bar')
    if isinstance(bar, dict):
        if bar.get('id') == 'radyalz.bar-control':
            bar['id'] = 'omarchy.bar'
        layout = bar.get('layout')
        if isinstance(layout, dict):
            for section in ('left', 'center', 'right'):
                layout[section] = [
                    entry for entry in layout.get(section, [])
                    if not (isinstance(entry, dict) and entry.get('id') in ids)
                ]
    data['plugins'] = [
        e for e in data.get('plugins', [])
        if not (isinstance(e, dict) and e.get('id') in ids)
    ]
    p.write_text(json.dumps(data, indent=2) + '\n')
PY

rm -rf "$plugin" "$split_launcher_plugin"
rm -f "$HOME/.local/bin/radyalz-bar-control-settings"
rm -f "$HOME/.local/share/applications/radyalz-bar-control.desktop"

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "$HOME/.local/share/applications" >/dev/null 2>&1 || true
fi
if command -v omarchy-shell >/dev/null 2>&1; then
  omarchy-shell shell rescanPlugins >/dev/null 2>&1 || true
fi
if command -v omarchy >/dev/null 2>&1; then
  omarchy restart shell
fi

printf 'Radyalz Bar Control has been uninstalled.\n'
printf 'Settings kept at %s\n' "$HOME/.config/omarchy/radyalz-bar-control.json"
