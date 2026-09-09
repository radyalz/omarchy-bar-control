Radyalz Bar Control v0.2.3

INSTALL
-------
Run:

  ./install.sh

The installer can now install from a clean Omarchy system. It seeds the runtime
from the currently installed Omarchy stock bar, then overlays Radyalz Bar
Control. If Animated Autohide Bar v0.2.2 is still installed, its settings are
migrated before the legacy plugin IDs are retired.

SETTINGS ACCESS
---------------
The installer asks one access-location question only. It is not a settings
wizard.

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

LOCAL DEVELOPMENT NOTES
-----------------------
The local docs/ directory is intentionally ignored by Git. It is reserved for
AI workflow rules, packaging helpers, and generated ChatGPT export bundles.

UNINSTALL
---------
Run:

  ./uninstall.sh

This returns the active bar to omarchy.bar and removes the plugin, launcher
widget, and desktop launcher.

SETTINGS PERSISTENCE
--------------------
Your settings are stored outside the installed plugin directory at:

  ~/.config/omarchy/radyalz-bar-control.json

This keeps animation, autohide, placement, and appearance choices intact when
the plugin directory is replaced during an Omarchy or plugin update. Uninstall
keeps this file by default so a later reinstall can restore the same settings.
