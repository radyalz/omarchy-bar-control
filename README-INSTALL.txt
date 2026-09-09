Radyalz Bar Control v0.2.3

This is the renamed successor to Animated Autohide Bar v0.2.2.

IMPORTANT FOR THE v0.2.2 -> v0.2.3 RENAME
------------------------------------------
Do not manually delete the old plugin directory first.

Run:

  ./install.sh

The installer performs the old-version uninstall/migration safely:

  1. Copies the inherited Islands Bar runtime files from the old working plugin.
  2. Preserves settings.json.
  3. Installs the renamed v0.2.3 files under:
       ~/.config/omarchy/plugins/radyalz.bar-control
  4. Replaces stale shell/plugin IDs.
  5. Moves the old plugin directories out of the live plugin registry into:
       ~/.local/state/radyalz-bar-control/legacy-<timestamp>/
  6. Restarts the Omarchy shell.

SETTINGS ACCESS
---------------
The installer asks one access-location question only. It is not a settings wizard.

  1. Left side of the bar
  2. Center of the bar
  3. Right side of the bar
  4. Linux app launcher only

A Linux application-menu entry named "Radyalz Bar Control" is always installed
as a fallback.

Non-interactive examples:

  ./install.sh --launcher left
  ./install.sh --launcher center
  ./install.sh --launcher right
  ./install.sh --launcher app

PLUGIN IDS
----------
Main plugin:
  radyalz.bar-control

Optional settings bar widget:
  radyalz.bar-control-launcher

AUTOHIDE MODULE
---------------
Autohide remains an activation module inside the permanent GUI. Turning it off
keeps Radyalz Bar Control installed and keeps the bar visible.

UNINSTALL v0.2.3
----------------
Run:

  ./uninstall.sh

This returns the active bar to omarchy.bar and removes the v0.2.3 plugin,
launcher widget, and desktop launcher.
