Radyalz Bar Control v0.4.5

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

PLUGIN ID
---------
One plugin provides everything:
  radyalz.bar-control

It registers the replacement bar, the settings service, the advanced settings
panel, and the optional quick-settings bar popover (a bar widget within the
same plugin). Installs from 0.4.2 and earlier that had a separate
radyalz.bar-control-launcher plugin are cleaned up on the next install.

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

This returns the active bar to omarchy.bar and removes the plugin (including
its popover bar widget) and the desktop launcher.

SETTINGS PERSISTENCE
--------------------
Your settings are stored outside the installed plugin directory at:

  ~/.config/omarchy/radyalz-bar-control.json

This keeps animation, autohide, placement, and appearance choices intact when
the plugin directory is replaced during an Omarchy or plugin update. Uninstall
keeps this file by default so a later reinstall can restore the same settings.
